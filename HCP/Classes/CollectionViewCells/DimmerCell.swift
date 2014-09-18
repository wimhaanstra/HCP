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

	override init(frame: CGRect) {
		
		self.dimValueLabel = UILabel(frame: CGRectMake(5, (frame.size.height / 2) - 30, frame.size.width - 10, 60));
		self.dimValueLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 40);
		self.dimValueLabel.textAlignment = NSTextAlignment.Center;
		
		self.dimValueLabel.text = "0";
		
		super.init(frame: frame);
		
		self.contentView.addSubview(self.dimValueLabel);
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		
		super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context);
		
		if (keyPath == "dimValue") {
			self.dimValueLabel.text = (self.sensor as Dimmer).dimValue?.stringValue;
		}
		
	}
}
