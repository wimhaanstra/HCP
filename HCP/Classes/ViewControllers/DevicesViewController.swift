//
//  DevicesViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class DevicesViewController: MenuViewController {

	var popOver:UIPopoverController! = nil;
	var addControllerButton: UIButton? = nil;
	
    override func viewDidLoad() {
        super.viewDidLoad()

		addControllerButton = self.addButton("Controllers", width: 150, selector: Selector("popupButton_Clicked"));
		self.addButton("Refresh all", width: 150, selector: Selector("popupButton_Clicked"));
	
		/*
		for recognizer in self.tableView.gestureRecognizers as [UIGestureRecognizer] {
			if let panGesture = recognizer as? UIPanGestureRecognizer {
				panGesture.requireGestureRecognizerToFail(self.swipeDownGesture!);
			}
		}
		*/
    }
	
	override func viewDidAppear(animated: Bool) {
	}
	
	func popupButton_Clicked() {
		
		var c: HomeWizardDiscoveryViewController = HomeWizardDiscoveryViewController();
		
		var navigationController = UINavigationController(rootViewController: c);
		
		self.popOver = UIPopoverController(contentViewController: navigationController);
		self.popOver.presentPopoverFromRect(addControllerButton!.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
