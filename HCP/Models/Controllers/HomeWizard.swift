//
//  HomeWizard.swift
//  HCP
//
//  Created by Wim Haanstra on 19/08/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import Foundation
import CoreData
import Realm

class HomeWizard: RLMObject {
    
    dynamic var name: String
    dynamic var version: String
    dynamic var lastUpdate: NSDate
    dynamic var ip: String
    
	class func discover(completion: (result: HomeWizard?) -> Void) {
		
		let discoveryUrl = "http://gateway.homewizard.nl/discovery.php";
		NSLog("Starting HomeWizard discovery");
		
		let manager = AFHTTPRequestOperationManager();
		
		manager.GET(discoveryUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
			
			if (responseObject.objectForKey("status") as String == "ok") {
				var ipAddress = responseObject.objectForKey("ip") as String
                let matches = HomeWizard.objectsWhere("ip = %@", ipAddress)
                
                if (matches.count == 0) {
                    var foundObject: HomeWizard = HomeWizard();
                    foundObject.ip = ipAddress;
                    foundObject.name = ipAddress;
                    foundObject.lastUpdate = NSDate.date();
                    
                    let realm = RLMRealm.defaultRealm();
                    
                    realm.beginWriteTransaction();
                    realm.addObject(foundObject);
                    realm.commitWriteTransaction();
                    
                    completion(result: foundObject);
                }
                else {
                    var foundObject: HomeWizard = matches[0] as HomeWizard
                    completion(result: foundObject)
                }
                
			}
            else {
                completion(result: nil);
            }
			
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
		
	}
    
    override init() {
        
        self.name = ""
        self.version = ""
        self.ip = ""
        self.lastUpdate = NSDate.date()
        
        super.init();
        
    }
	
}
