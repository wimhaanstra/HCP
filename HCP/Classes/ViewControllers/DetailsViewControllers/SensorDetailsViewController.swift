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
		self.initialize();
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented");
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
		
		self.initialize();
	}
	
	func initialize() {
		self.textLabel = UILabel(frame: CGRectMake(5, self.view.frame.size.height - 27, self.view.frame.size.width - 10, 30));
		self.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 16);
		self.textLabel!.textColor = UIColor.whiteColor();
		
		self.view.backgroundColor = UIColor.blackColor();
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
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
