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
		
		var predicate: NSPredicate = NSPredicate(format: "id = %d AND className = %@", id, NSStringFromClass(T));
		
		var addedSwitches = controller.sensors.filteredSetUsingPredicate(predicate);
		var sensor: T? = (addedSwitches.count == 0) ? nil : addedSwitches.allObjects[0] as? T;
		
		MagicalRecord.saveWithBlockAndWait { (context) -> Void in
			
			if (sensor == nil) {
				var localController = controller.inContext(context);
				
				logInfo("Sensor did not exist in DB");
				sensor = T.createEntityInContext(context);
				sensor?.id = id;
				sensor!.controller = localController;
				localController.addSensorsObject(sensor);
			}
			sensor?.update(definition);
		}
		
		return sensor;
	}
	
}
