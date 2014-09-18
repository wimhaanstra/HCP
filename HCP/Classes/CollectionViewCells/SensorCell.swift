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
				self.sensor!.removeObserversForView(self);
			}
		}
		didSet {
			
			if (self.sensor != nil) {
				self.textLabel.text = self.sensor!.displayName;
				
				self.sensor!.addObserversForView(self);
			}
			
		}
	}

	override init(frame: CGRect) {

		self.textLabel = UILabel(frame: CGRectMake(5, frame.size.height - 30, frame.size.width - 10, 30));
		self.textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16);
		self.textLabel.textColor = UIColor.whiteColor();

		super.init(frame: frame);

		self.contentView.addSubview(self.textLabel);
		self.cas_styleClass = "Sensor";
		
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		if (keyPath == "displayName") {
			self.textLabel.text = self.sensor!.displayName!.uppercaseString;
		}
		
	}
	
}
