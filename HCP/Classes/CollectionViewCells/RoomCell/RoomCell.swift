//
//  SensorCell.swift
//  HCP
//
//  Created by Wim Haanstra on 17/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class RoomCell: UICollectionViewCell {
	
	var textLabel: UILabel;
	
	var room: Room? {
		didSet {
			
			if (self.room != nil) {
				self.textLabel.text = self.room!.name!.uppercaseString;
			}
			
		}
	}
	
	override init(frame: CGRect) {
		
		self.textLabel = UILabel();
		self.textLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;
		self.textLabel.textAlignment = NSTextAlignment.Center;

		super.init(frame: frame);
		
		self.backgroundColor = UIColor(red: 0.151, green: 0.462, blue: 0.749, alpha: 1.0);
		
		self.contentView.addSubview(self.textLabel);
		self.cas_styleClass = "Room";
		
		self.textLabel.autoSetDimension(ALDimension.Height, toSize: 36);
		self.textLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 15, bottom: -6, right: 15), excludingEdge: ALEdge.Top);
		
		self.layer.cornerRadius = 20;
		self.layer.borderColor = UIColor.whiteColor().CGColor;
		self.layer.borderWidth = 1;
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
