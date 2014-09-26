//
//  ClockCell.swift
//  HCP
//
//  Created by Wim Haanstra on 20/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ClockCell: SensorCell {

	var clockLabel: UILabel;
	var clockTimer: NSTimer;

	override init(frame: CGRect) {
		
		self.clockTimer = NSTimer();
		
		self.clockLabel = UILabel(frame: CGRectMake(5, (frame.size.height / 2) - 30, frame.size.width - 10, 60));
		self.clockLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.clockLabel.adjustsFontSizeToFitWidth = true;
		self.clockLabel.textAlignment = NSTextAlignment.Center;
		self.clockLabel.textColor = UIColor.whiteColor();
		
		super.init(frame: frame);
		
		self.backgroundColor = UIColor(red: 0.422, green: 0.505, blue: 0.664, alpha: 1.0);
		self.clockTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("clockTimer_Tick"), userInfo: nil, repeats: true);
		
		self.contentView.addSubview(self.clockLabel);
		
		self.clockLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10));
	}
	
	override var sensor: Sensor? {
		didSet {
			
			self.updateTime();
			
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateTime() {
		if (self.sensor != nil) {
			
			var offset = ((self.sensor as Clock).timeZoneOffset == nil) ? 0 : (self.sensor as Clock).timeZoneOffset! * 3600;
			
			var formatter = NSDateFormatter();
			formatter.dateFormat = "HH:mm:ss";
			formatter.timeZone = NSTimeZone(forSecondsFromGMT: offset);
			self.clockLabel.text = formatter.stringFromDate(NSDate());
		}
	}
	
	func clockTimer_Tick() {
		self.updateTime();
	}
}
