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
		
		self.currentTemperatureLabel = UILabel();
		self.currentTemperatureLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.currentTemperatureLabel.textAlignment = NSTextAlignment.Center;
		self.currentTemperatureLabel.textColor = UIColor.whiteColor();
		
		super.init(frame: frame);

		self.backgroundColor = UIColor(red: 0.881, green: 0.646, blue: 0.147, alpha: 1.0);
		self.contentView.addSubview(self.currentTemperatureLabel);
		
		self.currentTemperatureLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10));

	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		if (keyPath == "temperature") {
			self.updateDisplay();
		}
		
	}
	
	override var sensor: Sensor? {
		didSet {
			self.updateDisplay();
		}
	}
	
	override func updateDisplay() {
		
		super.updateDisplay();
		
		if (self.sensor == nil) {
			return;
		}

		if let temperatureValue = (self.sensor as Thermometer).temperature as? CombinedValue {
			self.currentTemperatureLabel.text = "\(temperatureValue.currentValue)°C";
		}
	}
}
