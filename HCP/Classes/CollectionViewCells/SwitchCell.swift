//
//  SwitchCell.swift
//  HCP
//
//  Created by Wim Haanstra on 17/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class SwitchCell: SensorCell {
	
	var onButton: UIButton;
	var offButton: UIButton;
	
	var offBackgroundColor: UIColor = UIColor(red: 0.996, green: 0.710, blue: 0.506, alpha: 1.0);
	
	var onBackgroundColor: UIColor = UIColor(red: 0.902, green: 0.424, blue: 0.159, alpha: 1.0);

	override init(frame: CGRect) {
		
		self.onButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
		self.offButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;	
		
		super.init(frame: frame);

		self.textLabel.textColor = UIColor.whiteColor();
		
		self.onButton.cas_styleClass = "switch";
		self.onButton.addTarget(self, action: Selector("OnButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
		self.contentView.addSubview(self.onButton);

		self.onButton.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10));
	}
	
	override var sensor: Sensor? {
		didSet {
			if (self.sensor != nil) {
				self.backgroundColor = ((self.sensor as Switch).status == true) ? onBackgroundColor : offBackgroundColor;
				
				var text = ((self.sensor as Switch).status == true) ? "ON" : "OFF";
				self.onButton.setTitle(text, forState: .Normal);

			}
		}
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		
		if (keyPath == "status") {
			self.backgroundColor = ((self.sensor as Switch).status == true) ? onBackgroundColor : offBackgroundColor;
			var text = ((self.sensor as Switch).status == true) ? "ON" : "OFF";
			self.onButton.setTitle(text, forState: .Normal);
		}
		
	}
	
	func OnButton_Clicked() {
		
		if ((self.sensor as Switch).status == true) {
			(self.sensor! as Switch).off();
		}
		else {
			(self.sensor! as Switch).on();
		}
	}
	
	func OffButton_Clicked() {
		(self.sensor! as Switch).off();
	}

	
}
