//
//  ControllerManager.swift
//  HCP
//
//  Created by Wim Haanstra on 11/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ControllerManager {
	
	class var sharedInstance : ControllerManager {
		struct Static {
			static let instance: ControllerManager = ControllerManager();
		}
		
		return Static.instance;
	}
	
	private var controllers: [Controller] = [Controller]();
	
	init() {
		controllers = Controller.findAll() as [Controller];
		
		for item in controllers {
			
			if (item.ip! == "localhost") {
				self.markSensorsAvailable(item, available: true);
				item.start();
				continue;
			}

			let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
			
			if (item.ip!.rangeOfString(validIpAddressRegex, options: NSStringCompareOptions.RegularExpressionSearch, range:Range<String.Index>(start: item.ip!.startIndex, end: item.ip!.endIndex), locale: nil) != nil) {
				
				NSLog("IP: \(item.name)");
				
				var port = 80;
				
				var server_address = sockaddr_in(
					sin_len: __uint8_t(sizeof(sockaddr_in)),
					sin_family: sa_family_t(AF_INET),
					sin_port: in_port_t(80),
					sin_addr: in_addr(s_addr: inet_addr("10.0.0.60")),
					sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
				);
				
				item.reachabilityManager = AFNetworkReachabilityManager(forAddress: &server_address);
				//item.reachabilityManager = AFNetworkReachabilityManager(forDomain: item.ip!)
				
			}
			else {
				NSLog("DOMAIN: \(item.name)");
				item.reachabilityManager = AFNetworkReachabilityManager(forDomain: item.ip!)
			}
			
			item.reachabilityManager!.setReachabilityStatusChangeBlock({ (status) -> Void in
				
				switch(status) {
					case AFNetworkReachabilityStatus.NotReachable, AFNetworkReachabilityStatus.Unknown, AFNetworkReachabilityStatus.ReachableViaWWAN:
						NSLog("UNREACHABLE: \(item.name)");
						self.markSensorsAvailable(item, available: false);
						item.stop();
						break;
					case AFNetworkReachabilityStatus.ReachableViaWiFi:
						NSLog("Found \(item.name)");
						self.markSensorsAvailable(item, available: true);
						item.start();
						break;
				}
				
			});
			
			
			item.reachabilityManager!.startMonitoring();
			
			if (item.reachabilityManager!.reachable) {
				NSLog("IF Reachable \(item.name)");
				self.markSensorsAvailable(item, available: true);
				item.start();
			}
			else {
				NSLog("IF NotReachable \(item.name)");
				self.markSensorsAvailable(item, available: false);
				
			}
		}
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
	
	func allHomeWizards() -> [HomeWizard] {
		return controllers.filter({ $0.entityName == "HomeWizard" }) as [HomeWizard];
	}
	
	func addTime(controller: Controller, completion: (success: Bool) -> Void) {

		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			
			var localController: Time! = Time.createEntityInContext(context);
			
			if (localController != nil) {
				localController.name = controller.name;
				localController.ip = controller.ip;
				localController.lastUpdate = controller.lastUpdate;
			}

		}
		
		var controller = Time.findFirstByAttribute("ip", withValue: controller.ip);
		self.controllers.append(controller);
		controller.start();

		completion(success: true);
		
	}
	
	func markSensorsAvailable(controller: Controller, available: Bool) {
		
		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			
			for item in controller.sensors {
				
				NSLog("Marking sensor [\((item as Sensor).name)");
				(item as Sensor).available = available;
				
			}
			
		}
		
	}
	
	func addHomeWizard(controller: HomeWizard, completion: (success: Bool) -> Void) {
		
		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			var homeWizard: HomeWizard! = HomeWizard.createEntityInContext(context);
			
			if (homeWizard != nil) {
				homeWizard.name = controller.name;
				homeWizard.ip = controller.ip;
				homeWizard.lastUpdate = controller.lastUpdate;
				homeWizard.dataRefreshInterval = controller.dataRefreshInterval;
				homeWizard.sensorRefreshInterval = controller.sensorRefreshInterval;
			}
		};

		var controller = HomeWizard.findFirstByAttribute("ip", withValue: controller.ip);
		self.controllers.append(controller);
		controller.start();
		
		completion(success: true);
	}
	
	func stopControllers() {
		for item in self.controllers {
//			XCGLogger.defaultInstance().info("Stopping " + item.name!);
			item.stop();
		}
	}

}
