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
	
	override init(frame: CGRect) {
		
		self.currentUsageLabel = UILabel(frame: CGRectMake(5, (frame.size.height / 2) - 30, frame.size.width - 10, 60));
		self.currentUsageLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.currentUsageLabel.textAlignment = NSTextAlignment.Center;
		
		super.init(frame: frame);
		
		self.contentView.addSubview(self.currentUsageLabel);
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		if (keyPath == "used") {
			if let usedValue = (self.sensor as EnergyLink).used as? CombinedValue {
				self.currentUsageLabel.text = usedValue.currentValue.stringValue;
			}
		}
		
	}

}
