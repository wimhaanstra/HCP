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
		self.currentUsageLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 32);
		self.currentUsageLabel.textAlignment = NSTextAlignment.Center;
		self.currentUsageLabel.textColor = UIColor.whiteColor();
		self.currentUsageLabel.adjustsFontSizeToFitWidth = true;
		
		self.maxUsageLabel = UILabel(frame: CGRectMake(5, frame.size.height - 50, frame.size.width - 10, 24));
		self.maxUsageLabel.font = UIFont(name: "HelveticaNeue", size: 14);
		self.maxUsageLabel.textAlignment = NSTextAlignment.Center;
		self.maxUsageLabel.textColor = UIColor.whiteColor();
		
		super.init(frame: frame);
		
		self.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);

		self.contentView.addSubview(self.currentUsageLabel);
		self.contentView.addSubview(self.maxUsageLabel);
		self.contentView.addSubview(usageCircleView);
		
		self.currentUsageLabel.autoSetDimension(ALDimension.Height, toSize: 36);
		self.currentUsageLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self, withOffset: 15);
		self.currentUsageLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self, withOffset: -15);
		self.currentUsageLabel.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: self.contentView);
		
		self.maxUsageLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.currentUsageLabel);
		self.maxUsageLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self, withOffset: 40);
		self.maxUsageLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self, withOffset: -40);
		
		self.usageCircleView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10));
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
				
				var currentValue = usedValue.currentValue;
				var graphMax: NSNumber = (usedValue.maxValue.integerValue < usedValue.currentValue.integerValue) ? currentValue : usedValue.maxValue;
				var percentage: Double = currentValue / (graphMax / 100);

				self.usageCircleView.value = percentage;
				
				self.setNeedsDisplay();
			}
		}
		
	}
	
}
