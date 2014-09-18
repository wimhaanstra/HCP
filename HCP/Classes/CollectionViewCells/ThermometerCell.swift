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
		self.currentTemperatureLabel.font = UIFont(name: "HelveticaNeue", size: 32);
		self.currentTemperatureLabel.textAlignment = NSTextAlignment.Center;
		self.currentTemperatureLabel.textColor = UIColor.whiteColor();
		
		super.init(frame: frame);

		self.backgroundColor = UIColor(red: 1.0, green: 0.773, blue: 0.278, alpha: 1.0);
		self.contentView.addSubview(self.currentTemperatureLabel);
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		if (keyPath == "temperature") {
			if let temperatureValue = (self.sensor as Thermometer).temperature as? CombinedValue {
				self.currentTemperatureLabel.text = "\(temperatureValue.currentValue)°C";
			}
		}
		
	}


}
