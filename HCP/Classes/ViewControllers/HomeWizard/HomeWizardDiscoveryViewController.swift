//
//  HomeWizardDiscoveryViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 06/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class HomeWizardDiscoveryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	private var tableView: UITableView = UITableView();
	private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView();
	private var discoveredHomeWizards: [Controller] = [Controller]();
	private var passwordTextField: UITextField? = nil;
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.frame = self.view.bounds;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.autoresizingMask = .FlexibleHeight | .FlexibleWidth;
		self.view.addSubview(tableView);
		
		self.title = NSLocalizedString("HOMEWIZARD_DISCOVERY_TITLE", comment: "HomeWizard discovery popup titlte");
		
		self.preferredContentSize = CGSizeMake(320, 400);

	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		
		HomeWizard.discover(false, completion: { (results) -> Void in
			self.discoveredHomeWizards = results;
			self.tableView.reloadData();
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
			return ControllerManager.sharedInstance.allHomeWizards().count;
		}
		else {
			return self.discoveredHomeWizards.count;
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
				
				var storedHomeWizard: HomeWizard = ControllerManager.sharedInstance.allHomeWizards()[indexPath.row] as HomeWizard;
				
				cell.textLabel?.text = storedHomeWizard.description;
				cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
				
				return cell;
		}
		else { //if (indexPath.section == 1) {
			var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
			
			if (cell == nil) {
				cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
			}
			
			var discoveredHomeWizard: HomeWizard = self.discoveredHomeWizards[indexPath.row] as HomeWizard;
			
			cell.textLabel?.text = discoveredHomeWizard.description;
			
			cell.userInteractionEnabled = (discoveredHomeWizard.managedObjectContext == nil);
			cell.textLabel?.enabled = (discoveredHomeWizard.managedObjectContext == nil);
			cell.detailTextLabel?.enabled = (discoveredHomeWizard.managedObjectContext == nil);
			
			cell.accessoryType = (discoveredHomeWizard.managedObjectContext == nil) ? .None : .Checkmark;
			
			return cell;
		}
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);

		if (indexPath.section == 1) {
			
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
				
				var discoveredHomeWizard: HomeWizard = self.discoveredHomeWizards[indexPath.row] as HomeWizard;
				
				if (discoveredHomeWizard.managedObjectContext == nil) {
					var cell = tableView.cellForRowAtIndexPath(indexPath);
					
					discoveredHomeWizard.login(password, completion: { (success) -> Void in
						self.discoveredHomeWizards.removeAtIndex(indexPath.row);
						
						ControllerManager.sharedInstance.addHomeWizard(discoveredHomeWizard, completion: { (result) -> Void in
							self.tableView.reloadData();
						})
					});
				}
			}));
			
			self.presentViewController(alert, animated: true, completion: { () -> Void in
				
			});
		}
		else if (indexPath.section == 0) {
			var managementViewController = HomeWizardSensorManagementViewController();
			managementViewController.homeWizard = ControllerManager.sharedInstance.allHomeWizards()[indexPath.row] as HomeWizard;
			self.navigationController?.pushViewController(managementViewController, animated: true);
		}
	}
	
	
}
