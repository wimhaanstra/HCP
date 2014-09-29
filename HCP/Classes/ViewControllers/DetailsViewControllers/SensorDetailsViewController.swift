//
//  SensorDetailsViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 21/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class SensorDetailsViewController: UIViewController {

	var textLabel: UILabel = UILabel();
	var closeButton: UIButton = UIButton.buttonWithType(.Custom) as UIButton;
	
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
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 64);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;
		self.textLabel.alpha = 0.3;
		
		self.view.addSubview(self.textLabel);
		
		self.closeButton.setTitle("Close", forState: UIControlState.Normal);
		self.closeButton.addTarget(self, action: Selector("closeButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
		self.view.addSubview(self.closeButton);
		
		self.textLabel.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 3, -5, 3), excludingEdge: ALEdge.Top);
		self.textLabel.autoSetDimension(ALDimension.Height, toSize: 64);
		
		self.closeButton.autoSetDimensionsToSize(CGSizeMake(90, 44));
		self.closeButton.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5);
		self.closeButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 5);
    }
	
	override func viewWillAppear(animated: Bool) {

	}
	
	func closeButton_Clicked() {
		
		self.dismissFlipWithCompletion { () -> Void in
		}

	}
	
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
	}
	
	deinit {
		if (self.sensor != nil) {
			self.sensor!.removeObserversForObject(self);
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
