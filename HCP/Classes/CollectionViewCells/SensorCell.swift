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
				self.textLabel.text = self.sensor!.displayName!.uppercaseString;
				
				self.sensor!.addObserversForObject(self);
				
				if (self.sensor!.available! == false) {
					self.alpha = 0.2;
				}
				else {
					self.alpha = 1;
				}
			}
		}
	}
	
	override init(frame: CGRect) {
		
		self.textLabel = UILabel();
		self.textLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;

		
		super.init(frame: frame);
		
		self.backgroundColor = UIColor.blackColor();
		
		self.contentView.addSubview(self.textLabel);
		self.cas_styleClass = "Sensor";
		
		self.textLabel.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self, withOffset: 8);
		self.textLabel.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self, withOffset: 3);
		self.textLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self, withOffset: -3);
		self.textLabel.autoSetDimension(ALDimension.Height, toSize: 36);
		
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		if (self.sensor != nil) {
			if (keyPath == "displayName") {
				self.textLabel.text = self.sensor!.displayName!.uppercaseString;
			}
			
			if (keyPath == "available") {
				if (self.sensor!.available! == false) {
					self.alpha = 0.2;
				}
				else {
					self.alpha = 1;
				}
			}
		}
		
	}
	
}
