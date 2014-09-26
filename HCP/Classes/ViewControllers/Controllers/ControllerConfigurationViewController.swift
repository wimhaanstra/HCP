//
//  ControllerConfigurationViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 20/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

class ControllerConfigurationViewController: UIViewController, FXFormControllerDelegate {
	
	var tableView: UITableView = UITableView();
	var formController: FXFormController = FXFormController();
	
	var controller: Controller! = nil {
		didSet {
			
			if (self.controller != nil) {
				self.formController.form = self.controller;
				self.tableView.reloadData();
				
				self.title = self.controller.name;
			}
			
		}
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.initialize();
		
	}
	
	override init() {
		
		super.init();
		self.initialize();
		
	}
	
	func initialize() {
		self.view.addSubview(self.tableView);
		
		self.formController.tableView = self.tableView;
		self.formController.delegate = self;
		
		self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero);
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
		if (self.controller != nil) {
			self.controller.managedObjectContext.saveToPersistentStoreAndWait();
		}
	}
	
	
}
