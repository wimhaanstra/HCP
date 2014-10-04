//
//  DictionaryExtensions.swift
//  HCP
//
//  Created by Wim Haanstra on 01/10/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

extension NSDictionary {
	
	func isKeyOfClass(key: String, isOfClass: AnyClass) -> Bool {
		
		if (self.objectForKey(key) == nil || !self.objectForKey(key)!.isKindOfClass(isOfClass)) {
			return false;
		}
		else {
			return true;
		}
		
	}
	
	func featureKeysWithTypes(keysWithTypes: Dictionary<String, AnyClass>) -> Bool {
		
		if (!self.featureKeys(Array(keysWithTypes.keys))) {
			return false;
		}

		return true;
	}

	func featureKeys(keys: [String]) -> Bool {
		
		for item in keys {
			
			if (self.objectForKey(item) == nil) {
				return false;
			}
			
		}
		
		return true;
		
	}
	
}

extension Dictionary {
	
	func featuresKeys(keys: [Key]) -> Bool {
		
		for item in keys {
			
			if (self[item] == nil) {
				return false;
			}
			
		}
		
		return true;
		
	}
	
}
