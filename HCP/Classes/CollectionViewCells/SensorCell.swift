//
//  SensorCell.swift
//  HCP
//
//  Created by Wim Haanstra on 17/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class SensorCell: UICollectionViewCell {
	
	var textLabel: UILabel;
	
	var sensor: Sensor? {
		willSet {
			if (self.sensor != nil) {
				self.sensor!.removeObserversForObject(self);
			}
		}
		didSet {
			
			if (self.sensor != nil) {
				self.textLabel.alpha = (self.sensor!.showTitle == nil || self.sensor!.showTitle == true) ? 1.0 : 0.0;
				self.sensor!.addObserversForObject(self);
			}
			
			self.updateDisplay();
		}
	}
	
	override init(frame: CGRect) {
		
		self.textLabel = UILabel();
		self.textLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;
		self.textLabel.textAlignment = NSTextAlignment.Center;
		
		super.init(frame: frame);
		
		self.contentView.addSubview(self.textLabel);

		self.textLabel.autoSetDimension(ALDimension.Height, toSize: 36);
		self.textLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 15, bottom: -6, right: 15), excludingEdge: ALEdge.Top);
		
		self.cas_styleClass = "Sensor";
		self.backgroundColor = UIColor.blackColor();
		self.layer.cornerRadius = 20;
		
		self.layer.borderColor = UIColor.whiteColor().CGColor;
		self.layer.borderWidth = 1;
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
		
		if (self.sensor != nil) {
			self.updateDisplay();
		}
	}
	
	func updateDisplay() {
		
		if (sensor == nil) {
			return;
		}
		
		self.textLabel.text = self.sensor!.displayName!.uppercaseString;
		self.alpha = (self.sensor!.available! == false) ? 0.2 : 1;
	}
	
	deinit {
		if (self.sensor != nil) {
			self.sensor!.removeObserversForObject(self);
		}
	}
	
}
