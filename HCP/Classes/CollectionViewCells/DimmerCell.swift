//
//  DimmerCell.swift
//  HCP
//
//  Created by Wim Haanstra on 18/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class DimmerCell: SensorCell {
	
	var dimValueLabel: UILabel;
	
	var offBackgroundColor: UIColor = UIColor(red: 0.420, green: 0.671, blue: 0.278, alpha: 0.4); //UIColor(red: 0.644, green: 0.996, blue: 0.506, alpha: 1.0);
	var onBackgroundColor: UIColor = UIColor(red: 0.420, green: 0.671, blue: 0.278, alpha: 1.0);
	
	var valueCircleView: ProgressCircleView = ProgressCircleView();
	
	override var sensor: Sensor? {
		didSet {
			self.updateDisplay();
		}
	}

	override init(frame: CGRect) {
		
		self.dimValueLabel = UILabel();
		self.dimValueLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.dimValueLabel.textAlignment = NSTextAlignment.Center;
		self.dimValueLabel.adjustsFontSizeToFitWidth = true;
		self.dimValueLabel.textColor = UIColor.whiteColor();
//		self.dimValueLabel.backgroundColor = UIColor.blackColor();
		self.dimValueLabel.baselineAdjustment = UIBaselineAdjustment.AlignCenters;

		self.dimValueLabel.text = "0";
		
		super.init(frame: frame);
		
		self.contentView.addSubview(self.dimValueLabel);
		
		self.dimValueLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25));

		self.contentView.addSubview(valueCircleView);
		valueCircleView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7));

	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);

		self.updateDisplay();
	}
	
	override func updateDisplay() {
		
		super.updateDisplay();
		if (self.sensor == nil) {
			return;
		}
		
		self.dimValueLabel.text = "\((self.sensor as Dimmer).dimValue!)%";
		self.valueCircleView.value = (self.sensor as Dimmer).dimValue!.doubleValue;
		self.backgroundColor = ((self.sensor as Dimmer).status == true) ? onBackgroundColor : offBackgroundColor;
	}
}
