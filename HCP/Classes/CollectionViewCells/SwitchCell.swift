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

	override init(frame: CGRect) {
		
		self.onButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
		self.offButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;	
		
		super.init(frame: frame);
		
		self.onButton.frame = CGRectMake(10, 10, frame.size.width - 20, 44);
		self.onButton.setTitle("ON", forState: UIControlState.Normal);
		self.onButton.backgroundColor = UIColor.grayColor();
		self.onButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
		self.onButton.addTarget(self, action: Selector("OnButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
		self.contentView.addSubview(self.onButton);

		self.offButton.frame = CGRectMake(10, 64, frame.size.width - 20, 44);
		self.offButton.setTitle("OFF", forState: UIControlState.Normal);
		self.offButton.backgroundColor = UIColor.grayColor();
		self.offButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
		self.offButton.addTarget(self, action: Selector("OffButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
		self.contentView.addSubview(self.offButton);
	}

	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		
		if (keyPath == "status") {
			self.textLabel.text = self.sensor!.displayName!.uppercaseString;
		}
		
	}
	
	func OnButton_Clicked() {
		(self.sensor! as Switch).on();
	}
	
	func OffButton_Clicked() {
		(self.sensor! as Switch).off();
	}

}
