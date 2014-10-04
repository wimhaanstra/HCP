//
//  EntityFactory.swift
//  HCP
//
//  Created by Wim Haanstra on 09/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class EntityFactory<T: Sensor> {
	
	class func create(controller: Controller, definition: NSDictionary) -> T? {
		
		var id = definition.objectForKey("id") as Int;
		
		var predicate: NSPredicate? = NSPredicate(format: "id = %d AND className = %@", id, NSStringFromClass(T));
		
		var addedSwitches = controller.sensors.filteredSetUsingPredicate(predicate!);
		var sensor: T? = (addedSwitches.count == 0) ? nil : addedSwitches.allObjects[0] as? T;
		
		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			
			if (sensor == nil) {
				
				//XCGLogger.defaultInstance().info("Creating " + NSStringFromClass(T));
				var localController = controller.inContext(context);
				if (localController != nil) {
					sensor = T.createEntityInContext(context);
					sensor!.id = id;
					sensor!.selected = true;
					sensor!.available = true;
					sensor!.controller = localController;
					sensor!.sortOrder = controller.sensors.count;
					sensor!.onTodayScreen = false;
					sensor!.showTitle = true;
					localController.addSensorsObject(sensor);
				}
			}
			
			if (sensor!.sortOrder == nil) {
				sensor!.sortOrder = controller.sensors.count;
			}
			
			if (sensor!.available != true) {
				sensor?.available = true;
			}
			
			if (sensor != nil && sensor?.selected == true) {
				//XCGLogger.defaultInstance().info("Updating " + NSStringFromClass(T));
				sensor?.update(definition);
			}
		}
		
		return sensor;
	}
	
}
