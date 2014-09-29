//
//  RoomAddSensorViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 27/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class RoomAddSensorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var room: Room? = nil;
	private var tableView: UITableView = UITableView();
	
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
	
	func Close_Clicked() {
		self.dismissViewControllerAnimated(true, completion: { () -> Void in
		});
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ControllerManager.sharedInstance.allSensors(sortBy: "displayName").count;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
		
		if (cell == nil) {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
		}
		
		var sensor: Sensor = ControllerManager.sharedInstance.allSensors(sortBy: "displayName")[indexPath.row];
		
		cell.textLabel?.text = sensor.displayName;
		cell.accessoryType = UITableViewCellAccessoryType.None;
		
		if (self.room != nil && self.room!.sensors.containsObject(sensor)) {
			cell.accessoryType = .Checkmark;
		}
		
		return cell;
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true);
		
		var sensor: Sensor = ControllerManager.sharedInstance.allSensors(sortBy: "displayName")[indexPath.row];

		if (self.room!.sensors.containsObject(sensor)) {
			
		}
		else {
			MagicalRecord.saveWithBlockAndWait({ (context) -> Void in
				
				var localRoom = self.room!.inContext(context);
				var localSensor = sensor.inContext(context);
				localRoom.addSensorsObject(localSensor);
				
			})
			
			self.tableView.reloadData();
		}
		
	}
}
