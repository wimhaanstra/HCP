//
//  WeatherCell.swift
//  HCP
//
//  Created by Wim Haanstra on 30/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class WeatherCell: SensorCell {
	
	override init(frame: CGRect) {
		
		super.init(frame: frame);
		
		self.backgroundColor = UIColor(red: 0.604, green: 0.285, blue: 0.416, alpha: 1.0);
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
