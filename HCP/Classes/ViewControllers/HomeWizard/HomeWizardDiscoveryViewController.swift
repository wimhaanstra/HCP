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
	private var storedHomeWizards: [Controller] = [Controller]();
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.frame = self.view.bounds;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.autoresizingMask = .FlexibleHeight | .FlexibleWidth;
		self.view.addSubview(tableView);
		
		self.title = "HomeWizards";
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		
		storedHomeWizards = HomeWizard.findAll() as [Controller];
		
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
			return storedHomeWizards.count;
		}
		else {
			return discoveredHomeWizards.count;
		}
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0) {
			return "Added";
		}
		else {
			return "Discovered";
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if (indexPath.section == 0) {
				var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
				
				if (cell == nil) {
					cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
				}
				
				var storedHomeWizard: HomeWizard = self.storedHomeWizards[indexPath.row] as HomeWizard;
				
				cell.textLabel?.text = storedHomeWizard.description;
			
			/*
				cell.userInteractionEnabled = (storedHomeWizard.managedObjectContext == nil);
				cell.textLabel?.enabled = (storedHomeWizard.managedObjectContext == nil);
				cell.detailTextLabel?.enabled = (storedHomeWizard.managedObjectContext == nil);
			*/	
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
			var discoveredHomeWizard: HomeWizard = self.discoveredHomeWizards[indexPath.row] as HomeWizard;
			
			if (discoveredHomeWizard.managedObjectContext == nil) {
				var cell = tableView.cellForRowAtIndexPath(indexPath);
				
				MagicalRecord.saveWithBlock({ (context) -> Void in
					var homeWizard: HomeWizard! = HomeWizard.createEntityInContext(context);
					if (homeWizard != nil) {
						homeWizard.name = discoveredHomeWizard.name;
						homeWizard.ip = discoveredHomeWizard.ip;
						homeWizard.lastUpdate = discoveredHomeWizard.lastUpdate;
					}
					
					self.discoveredHomeWizards.removeAtIndex(indexPath.row);
					
					}, completion: { (success, error) -> Void in
						self.storedHomeWizards = HomeWizard.findAll() as [Controller];

						self.tableView.reloadData();
				});
			}
		}
		else if (indexPath.section == 0) {
			var managementViewController = HomeWizardSensorManagementViewController();
			managementViewController.homeWizard = self.storedHomeWizards[indexPath.row] as HomeWizard;
			self.navigationController?.pushViewController(managementViewController, animated: true);
		}
	}
	
	
}
