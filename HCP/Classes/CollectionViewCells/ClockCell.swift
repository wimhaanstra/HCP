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
	var secondsLabel: UILabel;
	var clockTimer: NSTimer;

	override init(frame: CGRect) {
		
		self.clockTimer = NSTimer();
		
		self.clockLabel = UILabel(frame: CGRectMake(5, (frame.size.height / 2) - 30, frame.size.width - 10, 60));
		self.clockLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 128);
		self.clockLabel.adjustsFontSizeToFitWidth = true;
		self.clockLabel.textAlignment = NSTextAlignment.Center;
		self.clockLabel.textColor = UIColor.whiteColor();
		self.clockLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters;
		
		self.secondsLabel = UILabel();
		self.secondsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 128);
		self.secondsLabel.adjustsFontSizeToFitWidth = true;
		self.secondsLabel.textAlignment = NSTextAlignment.Center;
		self.secondsLabel.textColor = UIColor.whiteColor();
		self.secondsLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters;

		super.init(frame: frame);
		
		self.backgroundColor = UIColor(red: 0.422, green: 0.505, blue: 0.664, alpha: 1.0);
		self.clockTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("clockTimer_Tick"), userInfo: nil, repeats: true);
		
		self.contentView.addSubview(self.clockLabel);
		self.contentView.addSubview(self.secondsLabel);
		
		self.clockLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10));
		self.secondsLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(10, 10, 10, 10));
	}
	
	override var sensor: Sensor? {
		didSet {
			self.updateDisplay();
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func updateDisplay() {
		
		super.updateDisplay();
		
		if (self.sensor == nil) {
			return;
		}
		
		self.secondsLabel.alpha = ((self.sensor as Clock).showSeconds == true) ? 0.1 : 0.0;

		var offset = Int((self.sensor as Clock).timeZoneOffset!.doubleValue * 3600);
		
		var formatter = NSDateFormatter();
		formatter.dateFormat = "HH:mm";

		formatter.timeZone = NSTimeZone(forSecondsFromGMT: offset);
		self.clockLabel.text = formatter.stringFromDate(NSDate());
		
		var secondFormatter = NSDateFormatter();
		secondFormatter.dateFormat = "ss";
		formatter.timeZone = NSTimeZone(forSecondsFromGMT: offset);
		self.secondsLabel.text = secondFormatter.stringFromDate(NSDate());
		
	}
	
	func clockTimer_Tick() {
		self.updateDisplay();
	}
}
