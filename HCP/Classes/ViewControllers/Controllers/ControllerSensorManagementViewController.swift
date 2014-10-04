//
//  HomeWizardSensorManagementViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 06/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ControllerSensorManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
	
	private var tableView: UITableView = UITableView();
	private var sensors: Array<Sensor> = [];
	
	var controller: Controller! = nil {
		didSet {
			
			self.title = controller.name;
			self.sensors = controller.sensors.allObjects as Array<Sensor>;
			self.sensors.sort({ $0.displayName < $1.displayName });
			
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.frame = self.view.bounds;
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.autoresizingMask = .FlexibleHeight | .FlexibleWidth;

		self.view.addSubview(tableView);
		
		self.preferredContentSize = CGSizeMake(320, 400);
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
			return self.controller.sensors.count;
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
			
			var sensor: Sensor = self.sensors[indexPath.row];
			cell.textLabel!.text = sensor.displayName;
			cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
			
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
				cell.textLabel?.textColor = UIColor.redColor();
				cell.accessoryType = .None;
				cell.textLabel?.text = "Delete";
			}
			
			return cell;
		}
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
		
		if (indexPath.section == 0) {
			
			var cell = tableView.cellForRowAtIndexPath(indexPath);
			var sensor: Sensor = self.sensors[indexPath.row];
			
			var sensorConfiguration = SensorConfigurationViewController();
			sensorConfiguration.sensor = sensor;
			self.navigationController?.pushViewController(sensorConfiguration, animated: true);
			
			
		}
		else if (indexPath.section == 1) {
			if (indexPath.row == 0) {
				var configuration = ControllerConfigurationViewController();
				configuration.controller = self.controller;
				self.navigationController?.pushViewController(configuration, animated: true);
			}
			else if (indexPath.row == 1) {
				
				var alert = UIAlertController(title: "Remove controller?", message: "Removing this controller will remove all settings that you configured.", preferredStyle: UIAlertControllerStyle.Alert);
				alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { ( action ) -> Void in
					
					ControllerManager.sharedInstance.remove(self.controller, completion: { (success) -> Void in
					});
					
					self.navigationController?.popToRootViewControllerAnimated(true);
				}));
				
				alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { ( action ) -> Void in
				}));
				
				self.presentViewController(alert, animated: true, completion: { () -> Void in
				});
			}
			
		}
	}
	
}
