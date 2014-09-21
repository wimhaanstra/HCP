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
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		self.tableView.frame = self.view.bounds;
		self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
		self.view.addSubview(self.tableView);
		
		self.formController.tableView = self.tableView;
		self.formController.delegate = self;
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			
			var closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("Close_Clicked"));
			self.navigationItem.rightBarButtonItem = closeButton;
			
		}
	}
	
	override init() {
		
		super.init();

		self.tableView.frame = self.view.bounds;
		self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
		self.view.addSubview(self.tableView);
		
		self.formController.tableView = self.tableView;
		self.formController.delegate = self;
		
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented");
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	override func viewWillDisappear(animated: Bool) {
		NSLog("Disappearing");
		
		self.sensor.managedObjectContext.saveToPersistentStoreAndWait();
	}
	
	func Close_Clicked() {
		self.dismissViewControllerAnimated(true, completion: { () -> Void in
			
		});
	}

}
