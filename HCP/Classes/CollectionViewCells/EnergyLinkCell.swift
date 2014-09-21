//
//  EnergyLinkCell.swift
//  HCP
//
//  Created by Wim Haanstra on 18/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class EnergyLinkCell: SensorCell {

	var currentUsageLabel: UILabel;
	var maxUsageLabel: UILabel;
	
	override init(frame: CGRect) {
		
		self.currentUsageLabel = UILabel(frame: CGRectMake(5, (frame.size.height / 2) - 30, frame.size.width - 10, 60));
		self.currentUsageLabel.font = UIFont(name: "HelveticaNeue", size: 32);
		self.currentUsageLabel.textAlignment = NSTextAlignment.Center;
		self.currentUsageLabel.textColor = UIColor.whiteColor();
		
		self.maxUsageLabel = UILabel(frame: CGRectMake(5, frame.size.height - 50, frame.size.width - 10, 24));
		self.maxUsageLabel.font = UIFont(name: "HelveticaNeue", size: 14);
		self.maxUsageLabel.textAlignment = NSTextAlignment.Center;
		self.maxUsageLabel.textColor = UIColor.whiteColor();
		
		super.init(frame: frame);
		
		self.backgroundColor = UIColor(white: 0.945, alpha: 1.0);
		self.contentView.addSubview(self.currentUsageLabel);
		self.contentView.addSubview(self.maxUsageLabel);
		self.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		if (keyPath == "used") {
			if let usedValue = (self.sensor as EnergyLink).used as? CombinedValue {
				self.currentUsageLabel.text = "\(usedValue.currentValue.stringValue) W";
				self.maxUsageLabel.text = "\(usedValue.maxValue.stringValue) W";
				self.setNeedsDisplay();
			}
		}
		
	}

	override func drawRect(rect: CGRect) {
		
		super.drawRect(rect);
		
		if let usedValue = (self.sensor as EnergyLink).used as? CombinedValue {
			
			var graphRect = CGRectInset(rect, rect.size.width / 10, rect.size.width / 10);
			var currentValue = usedValue.currentValue;
			
			var graphMax: NSNumber = (usedValue.maxValue.integerValue < usedValue.currentValue.integerValue) ? currentValue : usedValue.maxValue;
			
			var percentage: Double = currentValue / (graphMax / 100);

			self.drawCircleInRect(graphRect, color: UIColor(white: 0.800, alpha: 1.0), percentage: 100.0);
			
			var color = UIColor(red: 0.876, green: 0.265, blue: 0.217, alpha: 1.0);
			
			if (percentage <= 25) {
				color = UIColor(red: 0.383, green: 0.876, blue: 0.189, alpha: 1.0);
			}
			else if (percentage > 25 && percentage < 75) {
				color = UIColor(red: 0.876, green: 0.872, blue: 0.270, alpha: 1.0);
			}
			
			self.drawCircleInRect(graphRect, color: color, percentage: percentage);
		}
	}
	
	
	
	func drawCircleInRect(rect: CGRect, color: UIColor, percentage: Double) {
		
		var radius: Double = Double(rect.size.width / 2);
		var _value = (1.0/100.0) * ((percentage * 270) + (100 * 0) - (percentage * 0));
		var startAngle: Double = 135 * M_PI/180;
		var endAngle: Double = (135 + _value) * M_PI/180;
		var center: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));

		var ovalPattern: [CGFloat] = [1, 1, 1, 1];
		color.setStroke();
		
		var path = UIBezierPath(); //arcCenter: center, radius: 15, startAngle: startAngle, endAngle: endAngle, clockwise: false);
		path.addArcWithCenter(center, radius: CGFloat(radius), startAngle: CGFloat(135 * M_PI/180), endAngle: CGFloat(endAngle), clockwise: true);
		path.setLineDash(ovalPattern, count: 4, phase: 0);
		path.lineWidth = 12;
		path.stroke();

	}
	
}
