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
	private var homeWizards: [Controller] = [Controller]();
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.frame = self.view.bounds;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.autoresizingMask = .FlexibleHeight | .FlexibleWidth;
		self.view.addSubview(tableView);
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		
		HomeWizard.discover { (results) -> Void in
			self.homeWizards = results;
			self.tableView.reloadData();
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return homeWizards.count;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
		
		if (cell == nil) {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
		}
		
		var discoveredHomeWizard: HomeWizard = self.homeWizards[indexPath.row] as HomeWizard;
		
		cell.textLabel?.text = discoveredHomeWizard.description;
		
		cell.userInteractionEnabled = (discoveredHomeWizard.managedObjectContext == nil);
		cell.textLabel?.enabled = (discoveredHomeWizard.managedObjectContext == nil);
		cell.detailTextLabel?.enabled = (discoveredHomeWizard.managedObjectContext == nil);

		cell.accessoryType = (discoveredHomeWizard.managedObjectContext == nil) ? .None : .Checkmark;
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
		
		var discoveredHomeWizard: HomeWizard = self.homeWizards[indexPath.row] as HomeWizard;
		
		if (discoveredHomeWizard.managedObjectContext == nil) {
			var cell = tableView.cellForRowAtIndexPath(indexPath);
			
			MagicalRecord.saveWithBlock({ (context) -> Void in
				var homeWizard: HomeWizard! = HomeWizard.createEntityInContext(context);
				if (homeWizard != nil) {
					homeWizard.name = discoveredHomeWizard.name;
					homeWizard.ip = discoveredHomeWizard.ip;
					homeWizard.lastUpdate = discoveredHomeWizard.lastUpdate;
				}
				
				self.homeWizards.removeAtIndex(indexPath.row);
				self.homeWizards.append(homeWizard);
			}, completion: { (success, error) -> Void in
				self.tableView.reloadData();
			});
		}
		else {
			discoveredHomeWizard.deleteEntity();
			self.homeWizards.removeAtIndex(indexPath.row);
			self.tableView.reloadData();
		}
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
