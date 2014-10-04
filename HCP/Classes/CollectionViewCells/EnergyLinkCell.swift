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
	
	var usageCircleView: ProgressCircleView = ProgressCircleView();
	
	override init(frame: CGRect) {
		
		self.currentUsageLabel = UILabel();
		self.currentUsageLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 64);
		self.currentUsageLabel.textAlignment = NSTextAlignment.Center;
		self.currentUsageLabel.textColor = UIColor.whiteColor();
		self.currentUsageLabel.backgroundColor = UIColor.clearColor();
		self.currentUsageLabel.adjustsFontSizeToFitWidth = true;
		self.currentUsageLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters;
		
		self.maxUsageLabel = UILabel();
		self.maxUsageLabel.font = UIFont(name: "HelveticaNeue", size: 14);
		self.maxUsageLabel.textAlignment = NSTextAlignment.Center;
		self.maxUsageLabel.textColor = UIColor.whiteColor();
		self.maxUsageLabel.backgroundColor = UIColor.clearColor();

		self.maxUsageLabel.adjustsFontSizeToFitWidth = true;
		self.maxUsageLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters;
		
		super.init(frame: frame);
		
		self.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);

		self.contentView.addSubview(self.currentUsageLabel);
		self.contentView.addSubview(self.maxUsageLabel);
		self.contentView.addSubview(usageCircleView);
		
		self.currentUsageLabel.autoSetDimension(ALDimension.Height, toSize: 48);
		self.currentUsageLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self, withOffset: 25);
		self.currentUsageLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self, withOffset: -25);
		self.currentUsageLabel.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: self.contentView);
		
		self.maxUsageLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.currentUsageLabel);
		self.maxUsageLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self, withOffset: 40);
		self.maxUsageLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self, withOffset: -40);
		
		self.usageCircleView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7));
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var sensor: Sensor? {
		didSet {
			self.updateDisplay();
		}
	}
	
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		if (keyPath == "used") {
			self.updateDisplay();
		}
		
	}
	
	override func updateDisplay() {
		
		super.updateDisplay();
		
		if (self.sensor == nil) {
			return;
		}
		
		if let usedValue = (self.sensor as EnergyLink).used as? CombinedValue {
			self.currentUsageLabel.text = "\(usedValue.currentValue.stringValue) W";
			self.maxUsageLabel.text = "\(usedValue.maxValue.stringValue) W";
			
			var currentValue = usedValue.currentValue.intValue;
			var graphMax: Int32 = (usedValue.maxValue.intValue < usedValue.currentValue.intValue) ? currentValue : usedValue.maxValue.intValue;
			var percentage: Double = Double(currentValue) / (Double(graphMax) / 100);
			
			self.usageCircleView.value = percentage;
			
			self.setNeedsDisplay();
		}
	}
	
}
