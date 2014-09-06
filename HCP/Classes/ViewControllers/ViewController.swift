//
//  ViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 19/08/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var popOver:UIPopoverController! = nil;
	var popupButton: UIButton! = nil;
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		popupButton = UIButton();
		popupButton.setTitle("Discover HW", forState: .Normal);
		popupButton.setTitleColor(UIColor.blackColor(), forState: .Normal);
		popupButton.addTarget(self, action: Selector("popupButton_Clicked"), forControlEvents: .TouchUpInside);
	}
	
	override func viewDidAppear(animated: Bool) {
	
		popupButton.frame = CGRectMake(100, 100, 150, 44);
		self.view.addSubview(popupButton);
		
	}
	
	func popupButton_Clicked() {
		
		var c: HomeWizardDiscoveryViewController = HomeWizardDiscoveryViewController();
		
		var navigationController = UINavigationController(rootViewController: c);
		
		self.popOver = UIPopoverController(contentViewController: navigationController);
		self.popOver.presentPopoverFromRect(popupButton.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

