//
//  ArrayExtensions.swift
//  HCP
//
//  Created by Wim Haanstra on 11/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

extension Array {
	
	mutating func removeObject<U: Equatable>(object: U) {
		var index: Int?
		for (idx, objectToCompare) in enumerate(self) {
			if let to = objectToCompare as? U {
				if object == to {
					index = idx
				}
			}
		}
		
		if (index != nil) {
			self.removeAtIndex(index!)
		}
		
	}
}
