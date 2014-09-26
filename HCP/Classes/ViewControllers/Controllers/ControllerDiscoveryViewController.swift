//
//  ControllerDiscoveryViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 19/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ControllerDiscoveryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	private var tableView: UITableView = UITableView();
	private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
	private var discoveredControllers: [Controller] = [Controller]();
	private var passwordTextField: UITextField? = nil;
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.view.addSubview(tableView);
		
		self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero);
		
		self.title = NSLocalizedString("CONTROLLER_DISCOVERY_TITLE", comment: "Controller discovery popup titlte");
		
		self.preferredContentSize = CGSizeMake(320, 400);
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			
			var closeButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: Selector("Close_Clicked"));
			self.navigationItem.rightBarButtonItem = closeButton;
			
		}
		
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		
		HomeWizard.discover(false, completion: { (results) -> Void in
			self.discoveredControllers = results;
			
			Time.discover(false, completion: { (results) -> Void in
				
				for item in results {
					self.discoveredControllers.append(item);
				}
				
				YahooWeather.discover(false, completion: { (results) -> Void in
					
					for item in results {
						self.discoveredControllers.append(item);
					}
					
					self.tableView.reloadData();
				});
				
			})
		});
	}
	
	func Close_Clicked() {
		self.dismissViewControllerAnimated(true, completion: { () -> Void in
		});
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0) {
			return ControllerManager.sharedInstance.all().count;
		}
		else {
			return self.discoveredControllers.count;
		}
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0) {
			return NSLocalizedString("DISCOVERY_ADDED_SECTION_TITLE", comment: "Discovery added section title");
		}
		else {
			return NSLocalizedString("DISCOVERY_DISCOVERED_SECTION_TITLE", comment: "Discovery discovered section title");
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if (indexPath.section == 0) {
			var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
			
			if (cell == nil) {
				cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
			}
			
			var storedController: Controller = ControllerManager.sharedInstance.all()[indexPath.row] as Controller;
			
			cell.textLabel?.text = storedController.name;
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
			
			return cell;
		}
		else { //if (indexPath.section == 1) {
			var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
			
			if (cell == nil) {
				cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
			}
			
			var discoveredController = self.discoveredControllers[indexPath.row];
			
			cell.textLabel?.text = discoveredController.name;
			
			cell.userInteractionEnabled = (discoveredController.managedObjectContext == nil);
			cell.textLabel?.enabled = (discoveredController.managedObjectContext == nil);
			cell.detailTextLabel?.enabled = (discoveredController.managedObjectContext == nil);
			
			cell.accessoryType = (discoveredController.managedObjectContext == nil) ? .None : .Checkmark;
			
			return cell;
		}
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
		
		if (indexPath.section == 1) {
			var controller = self.discoveredControllers[indexPath.row] as Controller;
			
			switch (controller.type) {
			case .HomeWizard:
				self.addHomeWizard(controller as HomeWizard, indexPath: indexPath);
			case .Time, .Weather:
				self.addController(controller, indexPath: indexPath);
			case .HueBridge:
				println("Hue");
			default:
				println("Unknown");
			}
		}
		else if (indexPath.section == 0) {
			var controller = ControllerManager.sharedInstance.all()[indexPath.row];
			
			var managementViewController = ControllerSensorManagementViewController();
			managementViewController.controller = controller;
			self.navigationController?.pushViewController(managementViewController, animated: true);
		}
	}
	
	func addController(controller: Controller, indexPath: NSIndexPath) {
		
		ControllerManager.sharedInstance.add(controller, completion: { (success) -> Void in
			if (success) {
				self.discoveredControllers.removeAtIndex(indexPath.row);
				self.tableView.reloadData();
			}
			else {
				//				XCGLogger.defaultInstance().error("Error logging in on HomeWizard");
			}
		});
		
	}
	
	func addHomeWizard(controller: HomeWizard, indexPath: NSIndexPath) {
		var alert = UIAlertController(title: "Please log in", message: "You need to enter the password for this HomeWizard", preferredStyle: UIAlertControllerStyle.Alert);
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Password";
			textField.secureTextEntry = true;
			self.passwordTextField = textField;
		});
		
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
			
			if (self.passwordTextField == nil || self.passwordTextField?.text! == "") {
				return;
			}
			
			var password: String = self.passwordTextField!.text;
			
			if (controller.managedObjectContext == nil) {
				controller.login(password, completion: { (success) -> Void in
					
					if (success) {
						self.discoveredControllers.removeAtIndex(indexPath.row);
						
						ControllerManager.sharedInstance.add(controller, completion: { (result) -> Void in
							self.tableView.reloadData();
						})
					}
					else {
						var errorAlert = UIAlertController(title: "Error connecting", message: "There was an error connecting to your HomeWizard", preferredStyle: UIAlertControllerStyle.Alert);
						errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
						}));
						
						self.presentViewController(errorAlert, animated: true, completion: { () -> Void in
							
						});
					}
				});
			}
		}));
		
		self.presentViewController(alert, animated: true, completion: { () -> Void in
			
		});
	}
	
}
