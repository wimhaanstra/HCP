//
//  BaseController.swift
//  HCP
//
//  Created by Wim Haanstra on 19/08/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import Foundation
import Realm

class BaseController: RLMObject {

    dynamic var name: String
    dynamic var version: String
    dynamic var lastUpdate: NSDate
    dynamic var ip: String
    dynamic var mac: String
	
	class func discover(completion: (results: [BaseController]) -> Void) {
	}
    
    override init() {
        
        self.name = ""
        self.version = ""
        self.ip = ""
        self.mac = ""
        self.lastUpdate = NSDate.date()
        
        super.init();
        
    }

}
