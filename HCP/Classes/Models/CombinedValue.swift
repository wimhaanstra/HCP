//
//  CombinedValue.swift
//  HCP
//
//  Created by Wim Haanstra on 09/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class CombinedValue: NSObject, NSCoding {
	
	var maxTime: String = "";
	var maxValue: NSNumber = 0;
	
	var minTime: String = "";
	var minValue: NSNumber = 0;
	
	var currentValue: NSNumber = 0;
	
	var lastUpdate: NSDate = NSDate();
	var total: NSNumber = 0;
	
	var lastHour: NSNumber = 0;
	
	override init() {
		super.init();
	}
	
	required init(coder aDecoder: NSCoder) {
		
		super.init();
		
		self.maxTime = aDecoder.decodeObjectForKey("maxTime") as String;
		self.maxValue = aDecoder.decodeObjectForKey("maxValue") as NSNumber;

		self.minTime = aDecoder.decodeObjectForKey("minTime") as String;
		self.minValue = aDecoder.decodeObjectForKey("minValue") as NSNumber;
		
		self.currentValue = aDecoder.decodeObjectForKey("currentValue") as NSNumber;
		self.total = aDecoder.decodeObjectForKey("total") as NSNumber;
	
		self.lastUpdate = aDecoder.decodeObjectForKey("lastUpdate") as NSDate;
		self.lastHour = aDecoder.decodeObjectForKey("lastHour") as NSNumber;
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.maxTime, forKey: "maxTime");
		aCoder.encodeObject(self.maxValue, forKey: "maxValue");

		aCoder.encodeObject(self.minTime, forKey: "minTime");
		aCoder.encodeObject(self.minValue, forKey: "minValue");
		
		aCoder.encodeObject(self.currentValue, forKey: "currentValue");
		aCoder.encodeObject(self.total, forKey: "total");
		
		aCoder.encodeObject(self.lastHour, forKey: "lastHour");
		aCoder.encodeObject(self.lastUpdate, forKey: "lastUpdate");
		
	}
	
	init(itemDictionary: NSDictionary) {

		super.init();
		
		if let max = itemDictionary.objectForKey("po+") as? NSNumber {
			self.maxValue = max;
		}
		
		if let min = itemDictionary.objectForKey("po-") as? NSNumber {
			self.minValue = min;
		}
		
		if let minTime = itemDictionary.objectForKey("po-t") as? String {
			self.minTime = minTime;
		}

		if let maxTime = itemDictionary.objectForKey("po+t") as? String {
			self.maxTime = maxTime;
		}

		if let currentValue = itemDictionary.objectForKey("po") as? NSNumber {
			self.currentValue = currentValue;
		}
		
		if let dayTotal = itemDictionary.objectForKey("dayTotal") as? NSNumber {
			self.total = dayTotal;
		}

		if let lastHour = itemDictionary.objectForKey("lastHour") as? NSNumber {
			self.lastHour = lastHour;
		}
		
		self.lastUpdate = NSDate();
	}
   
}