//
//  HomeWizardSensorManagementViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 06/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class HomeWizardSensorManagementViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
	
	private var tableView: UITableView = UITableView();
	private var sensors: Array<Sensor> = [];
	
	var homeWizard: HomeWizard! = nil {
		didSet {
			
			self.title = homeWizard.name;
			self.sensors = homeWizard.sensors.allObjects as Array<Sensor>;
			self.sensors.sort({ $0.name < $1.name });
			
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
			return self.homeWizard.sensors.count;
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
			cell.textLabel!.text = sensor.name;
			
			if (sensor.selected == true) {
				cell.accessoryType = .Checkmark;
			}
			else {
				cell.accessoryType = .None;
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
				cell.textLabel?.textColor = UIColor.redColor();
				cell.accessoryType = .None;
				cell.textLabel?.text = "Remove HomeWizard";
			}
			
			return cell;
		}
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
		
		if (indexPath.section == 0) {
			
			var cell = tableView.cellForRowAtIndexPath(indexPath);
			var sensor: Sensor = self.sensors[indexPath.row];
			
			MagicalRecord.saveWithBlockAndWait({ (context) -> Void in
				var sensorInContext:Sensor = sensor.inContext(context);
				
				if (sensor.selected == true) {
					cell?.accessoryType = .None;
					sensor.selected = false;
					sensorInContext.selected = false;
				}
				else {
					sensor.selected = true;
					sensorInContext.selected = true;
					cell?.accessoryType = .Checkmark;
				}
				
			});
			
		}
		else if (indexPath.section == 1) {
			
			if (indexPath.row == 1) {
				
				var alert = UIAlertController(title: "Remove HomeWizard?", message: "Removing this HomeWizard will remove all settings that you configured.", preferredStyle: UIAlertControllerStyle.Alert);
				alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { ( action ) -> Void in
					
					ControllerManager.sharedInstance.remove(self.homeWizard, completion: { (success) -> Void in
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
