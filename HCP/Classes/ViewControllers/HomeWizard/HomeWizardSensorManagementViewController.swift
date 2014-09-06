//
//  HomeWizardSensorManagementViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 06/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class HomeWizardSensorManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	private var tableView: UITableView = UITableView();
	
	
	var homeWizard: HomeWizard! = nil {
		didSet {
			self.title = homeWizard.name;
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.frame = self.view.bounds;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.autoresizingMask = .FlexibleHeight | .FlexibleWidth;

		self.view.addSubview(tableView);
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
			return 0;
		}
		else {
			return 2;
		}
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0) {
			return "Sensors";
		}
		else {
			return "Management";
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if (indexPath.section == 0) {
			var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
			
			if (cell == nil) {
				cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
			}
			
			return cell;
		}
		else { //if (indexPath.section == 1) {
			
			var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
			if (cell == nil) {
				cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
			}

			cell.accessoryType = UITableViewCellAccessoryType.None;
			
			if (indexPath.row == 0) {
				cell.textLabel?.textColor = UIColor.blackColor();
				cell.textLabel?.text = "Settings";
				cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
			}
			else if (indexPath.row == 1) {
				cell.backgroundColor = UIColor.redColor();
				cell.textLabel?.textColor = UIColor.whiteColor();
				cell.textLabel?.text = "Remove HomeWizard";
			}
			
			return cell;
		}
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
		
		if (indexPath.section == 0) {
		}
		else if (indexPath.section == 1) {
			
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
