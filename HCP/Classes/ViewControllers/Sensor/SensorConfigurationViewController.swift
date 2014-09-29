//
//  SensorConfigurationViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 19/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class SensorConfigurationViewController: UIViewController, FXFormControllerDelegate {

	var tableView: UITableView = UITableView();
	var formController: FXFormController = FXFormController();
	
	var sensor: Sensor! = nil {
		didSet {
			
			if (self.sensor != nil) {
				self.formController.form = self.sensor;
				self.tableView.reloadData();
				
				self.title = self.sensor.displayName;
			}
			
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.addSubview(self.tableView);
		self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero);
		
		self.formController.tableView = self.tableView;
		self.formController.delegate = self;
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			
			var closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("Close_Clicked"));
			self.navigationItem.rightBarButtonItem = closeButton;
			
		}

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func viewWillDisappear(animated: Bool) {
		self.sensor.managedObjectContext.saveToPersistentStoreAndWait();
	}
	
	func Close_Clicked() {
		self.dismissViewControllerAnimated(true, completion: { () -> Void in
		});
	}

}
