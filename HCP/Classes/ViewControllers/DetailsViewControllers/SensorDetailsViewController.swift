//
//  SensorDetailsViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 21/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class SensorDetailsViewController: UIViewController {

	var textLabel: UILabel?;
	var closeButton: UIButton?;
	
	var sensor: Sensor? {
		willSet {
			if (self.sensor != nil) {
				self.sensor!.removeObserversForObject(self);
			}
		}
		didSet {
			if (self.sensor != nil) {
				self.textLabel!.text = self.sensor!.displayName!.uppercaseString;
				self.sensor!.addObserversForObject(self);
			}
		}
	}
	
	override init() {
		super.init();
		initialize();
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented");
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
		initialize();
	}
	
	func initialize() {
		self.textLabel = UILabel(frame: CGRectMake(1, self.view.frame.size.height - 60, self.view.frame.size.width - 10, 64));
		self.textLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 64);
		self.textLabel!.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth;
		self.textLabel!.textColor = UIColor.whiteColor();
		self.textLabel!.adjustsFontSizeToFitWidth = true;
	
		self.closeButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton;
		self.closeButton!.setTitle("Close", forState: UIControlState.Normal);
		self.closeButton!.frame = CGRectMake(self.view.frame.size.width - 95, 5, 90, 44);
		self.closeButton!.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleLeftMargin;
		self.closeButton!.addTarget(self, action: Selector("closeButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		self.view.addSubview(self.textLabel!);
		self.view.addSubview(self.closeButton!);

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
