//
//  ControllerManager.swift
//  HCP
//
//  Created by Wim Haanstra on 11/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit
import HomeKit

class ControllerManager : NSObject, HMHomeManagerDelegate {
	
	class var sharedInstance : ControllerManager {
		struct Static {
			static let instance: ControllerManager = ControllerManager();
		}
		
		return Static.instance;
	}
	
	private var controllers: [Controller] = [Controller]();
	
	var homeManager: HMHomeManager = HMHomeManager();
	
	override init() {
		super.init();
		
		controllers = Controller.findAll() as [Controller];
		
		self.homeManager.delegate = self;
		
		for item in controllers {
			
			if (item.ip == nil) {
				continue;
			}
			
			if (item.ip! == "localhost") {
				self.setSensorAvailability(item, available: true);
				item.start();
				continue;
			}

			let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
			
			if (item.ip!.rangeOfString(validIpAddressRegex, options: NSStringCompareOptions.RegularExpressionSearch, range:Range<String.Index>(start: item.ip!.startIndex, end: item.ip!.endIndex), locale: nil) != nil) {
				
				var port = 80;
				
				var server_address = sockaddr_in(
					sin_len: __uint8_t(sizeof(sockaddr_in)),
					sin_family: sa_family_t(AF_INET),
					sin_port: in_port_t(80),
					sin_addr: in_addr(s_addr: inet_addr("10.0.0.60")),
					sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
				);
				
				item.reachabilityManager = AFNetworkReachabilityManager(forAddress: &server_address);
			}
			else {
				item.reachabilityManager = AFNetworkReachabilityManager(forDomain: item.ip!)
			}
			
			item.reachabilityManager!.setReachabilityStatusChangeBlock({ (status) -> Void in
				
				switch(status) {
					case AFNetworkReachabilityStatus.NotReachable, AFNetworkReachabilityStatus.Unknown, AFNetworkReachabilityStatus.ReachableViaWWAN:
						self.setSensorAvailability(item, available: false);
						item.stop();
						break;
					case AFNetworkReachabilityStatus.ReachableViaWiFi:
						self.setSensorAvailability(item, available: true);
						item.start();
						break;
				}
				
			});
			
			
			item.reachabilityManager!.startMonitoring();
			
			if (item.reachabilityManager!.reachable) {
				self.setSensorAvailability(item, available: true);
				item.start();
			}
			else {
				self.setSensorAvailability(item, available: false);
				
			}
		}
	}
	
	func add(controller: Controller, completion: (success: Bool) -> Void) {
		
		if (controller.managedObjectContext == nil) {
			
			NSManagedObjectContext.rootSavingContext().insertObject(controller);
			NSManagedObjectContext.rootSavingContext().saveOnlySelfAndWait();
			
		}
		
		self.controllers.append(controller);
		controller.start();
		
		completion(success: true);
		
	}
	
	func remove(controller: Controller, completion: (success: Bool) -> Void) {
		
		controller.stop();
		
		MagicalRecord.saveWithBlock({ (context) -> Void in
			var controllerInContext: Controller = controller.inContext(context);
			controllerInContext.deleteEntity();
		}, completion: { (success, error) -> Void in
			
			self.controllers.removeObject(controller);
			
			completion(success: true);
		});
	}
	
	func all() -> [Controller] {
		return controllers;
	}
	
	func setSensorAvailability(controller: Controller, available: Bool) {
		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			
			for item in controller.sensors {
				(item as Sensor).available = available;
			}
			
		}
	}
	
	func moveSenor(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> [Sensor] {
		
		var sensors = self.allSensors();

		var sensor = sensors[fromIndexPath.row];
		sensors.removeAtIndex(fromIndexPath.row);
		sensors.insert(sensor, atIndex: toIndexPath.row);

		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			
			var index = 0;
			for item in sensors {
				var localItem = item.inContext(context);
				localItem.sortOrder = index;
				index++;
			}
		}
		
		return sensors;
	}
	
	func allSensors(sortBy: String = "sortOrder") -> [Sensor] {

		var predicate = NSPredicate(format: "selected = %@", argumentArray: [ true ] );
		return Sensor.findAllSortedBy(sortBy, ascending: true, withPredicate: predicate) as [Sensor];

	}

	func stopControllers() {
		for item in self.controllers {
//			XCGLogger.defaultInstance().info("Stopping " + item.name!);
			item.stop();
		}
	}
	
	/* HomeManager Delegate Methods */
	
	func homeManagerDidUpdateHomes(manager: HMHomeManager!) {
	
		XCGLogger.defaultInstance().debug("HomeKit: HMHomeManager initialized");
		
		if (self.homeManager.homes.count == 0) {
			self.homeManager.addHomeWithName("My Home", completionHandler: { (home, error) -> Void in
				
				if (error != nil) {
					XCGLogger.defaultInstance().error("HomeKit: " + error.localizedDescription);
				}
				else {
					XCGLogger.defaultInstance().debug("HomeKit: Created default home called 'My Home'");
				}
				
			});
		}
		else {
			XCGLogger.defaultInstance().debug("HomeKit: A Home is already present");
		}
	}

	func discoverControllers(completion: (results: [Controller]) -> Void) {
		
		var controllerClasses: [Controller.Type] = [ HomeKit.self, HomeWizard.self, Time.self, YahooWeather.self, HueBridge.self ];
		var controllers: [Controller] = [Controller]();
		var completed = 0;

		for item in controllerClasses {
			item.discover(false, completion: { (results) -> Void in
				for item in results {
					controllers.append(item);
				}
				
				completed++;
				if (completed == controllerClasses.count) {
					controllers.sort( {$0.name < $1.name });
					completion(results: controllers);
				}
			});
		}
	}
	
}
