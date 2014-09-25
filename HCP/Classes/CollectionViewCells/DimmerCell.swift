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
	
	override var sensor: Sensor? {
		didSet {
			self.dimValueLabel.text = "\((self.sensor as Dimmer).dimValue!)%";
			self.backgroundColor = ((self.sensor as Dimmer).status == true) ? onBackgroundColor : offBackgroundColor;
		}
	}

	override init(frame: CGRect) {
		
		self.dimValueLabel = UILabel();
		self.dimValueLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.dimValueLabel.textAlignment = NSTextAlignment.Center;
		self.dimValueLabel.textColor = UIColor.whiteColor();
		
		self.dimValueLabel.text = "0";
		
		super.init(frame: frame);
		
		self.contentView.addSubview(self.dimValueLabel);
		
		self.dimValueLabel.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self);
		self.dimValueLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self, withOffset: 10);
		self.dimValueLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self, withOffset: -10);
		self.dimValueLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self);

	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		
		if (keyPath == "dimValue" && (self.sensor as Dimmer).dimValue != nil) {
			self.dimValueLabel.text = "\((self.sensor as Dimmer).dimValue!)%";
		}
		
		self.backgroundColor = ((self.sensor as Dimmer).status == true) ? onBackgroundColor : offBackgroundColor;
		
	}
}
