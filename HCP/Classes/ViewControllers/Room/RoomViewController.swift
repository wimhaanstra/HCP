//
//  RoomViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 26/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class RoomViewController: MenuViewController, UIPopoverControllerDelegate {
	
	var closeButton: UIButton = UIButton.buttonWithType(.Custom) as UIButton;
	var textLabel: UILabel = UILabel();
	var popOver:UIPopoverController? = nil;
	var addSensorButton: UIButton = UIButton.buttonWithType(.Custom) as UIButton;

	var room: Room? {
		didSet {
			if (self.room != nil) {
				self.textLabel.text = self.room!.name!.uppercaseString
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		addSensorButton = self.addButton(NSLocalizedString("ADD_SENSOR_BUTTON", comment: "Button title in room view"), width: 150, selector: Selector("addSensorButton_Clicked"));

		self.view.backgroundColor = UIColor.grayColor();
		
		self.textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 64);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;
		self.textLabel.alpha = 0.3;
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
	
	func addSensorButton_Clicked() {
		
		var c: RoomAddSensorViewController = RoomAddSensorViewController();
		c.room = self.room!;
		var navigationController = UINavigationController(rootViewController: c);
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			self.containerViewController!.presentViewController(navigationController, animated: true, completion: { () -> Void in
			});
			
		}
		else {
			self.popOver = UIPopoverController(contentViewController: navigationController);
			self.popOver!.delegate = self;
			self.popOver!.presentPopoverFromRect(addSensorButton.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
		}
		
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
