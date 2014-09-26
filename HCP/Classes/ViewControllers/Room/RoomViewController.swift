//
//  RoomViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 26/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class RoomViewController: MenuViewController {
	
	var closeButton: UIButton = UIButton.buttonWithType(.Custom) as UIButton;
	var textLabel: UILabel = UILabel();

	var room: Room? {
		didSet {
			if (self.room != nil) {
				self.textLabel.text = self.room!.name!.uppercaseString
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.grayColor();
		
		self.textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 64);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;
		self.contentView.addSubview(self.textLabel);

		self.closeButton.setTitle("Close", forState: UIControlState.Normal);
		self.closeButton.addTarget(self, action: Selector("closeButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
		self.contentView.addSubview(self.closeButton);
		
		self.closeButton.autoSetDimensionsToSize(CGSizeMake(90, 44));
		self.closeButton.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5);
		self.closeButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 5);

		self.textLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 3, -5, 3), excludingEdge: ALEdge.Top);
		self.textLabel.autoSetDimension(ALDimension.Height, toSize: 64);
    }
	
	func closeButton_Clicked() {
		self.dismissFlipWithCompletion { () -> Void in
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
