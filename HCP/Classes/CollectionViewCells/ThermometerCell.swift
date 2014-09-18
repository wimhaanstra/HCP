//
//  ThermometerCell.swift
//  HCP
//
//  Created by Wim Haanstra on 18/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ThermometerCell: SensorCell {

	var currentTemperatureLabel: UILabel;
	
	override init(frame: CGRect) {
		
		self.currentTemperatureLabel = UILabel(frame: CGRectMake(5, (frame.size.height / 2) - 30, frame.size.width - 10, 60));
		self.currentTemperatureLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.currentTemperatureLabel.textAlignment = NSTextAlignment.Center;
		
		super.init(frame: frame);
		
		self.contentView.addSubview(self.currentTemperatureLabel);
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		if (keyPath == "temperature") {
			if let temperatureValue = (self.sensor as Thermometer).temperature as? CombinedValue {
				self.currentTemperatureLabel.text = temperatureValue.currentValue.stringValue;
			}
		}
		
	}


}
