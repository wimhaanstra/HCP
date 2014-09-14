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
			item.start();
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
	
	func allHomeWizards() -> [HomeWizard] {
		return controllers.filter({ $0.entityName == "HomeWizard" }) as [HomeWizard];
	}
	
	func addHomeWizard(controller: Controller, completion: (success: Bool) -> Void) {
		
		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			var homeWizard: HomeWizard! = HomeWizard.createEntityInContext(context);
			
			if (homeWizard != nil) {
				homeWizard.name = controller.name;
				homeWizard.ip = controller.ip;
				homeWizard.lastUpdate = controller.lastUpdate;
			}
		};

		var controller = Controller.findFirstByAttribute("ip", withValue: controller.ip);
		self.controllers.append(controller);
		controller.start();
		
		completion(success: true);
	}
	
	func stopControllers() {
		for item in self.controllers {
			logInfo("Stopping " + item.name!);
			item.stop();
		}
	}

}
