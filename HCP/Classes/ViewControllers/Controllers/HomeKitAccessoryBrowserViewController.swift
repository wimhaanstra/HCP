//
//  HomeKitAccessoryBrowserViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 30/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit
import HomeKit

class HomeKitAccessoryBrowserViewController: UIViewController, HMAccessoryBrowserDelegate, UITableViewDataSource, UITableViewDelegate {
	
	private var accessories = [HMAccessory]();

	var tableView = UITableView();
	var accessoryBrowser = HMAccessoryBrowser();
	var homeKit: HomeKit? {
		didSet {
			
			if (self.homeKit != nil) {
				self.title = self.homeKit!.name!;
			}
		}
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()

		accessoryBrowser.delegate = self;
		accessoryBrowser.startSearchingForNewAccessories();
		
		self.view.addSubview(self.tableView);
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func accessoryBrowser(browser: HMAccessoryBrowser!, didFindNewAccessory accessory: HMAccessory!) {
		if (accessory.identifiersForBridgedAccessories == nil) {
			NSLog("Non-bridge");
		}
		else {
			NSLog("Bridge");
		}
		
		self.accessories = browser.discoveredAccessories as [HMAccessory];
		self.tableView.reloadData();
	}
	
	func accessoryBrowser(browser: HMAccessoryBrowser!, didRemoveNewAccessory accessory: HMAccessory!) {
		
		self.accessories = browser.discoveredAccessories as [HMAccessory];
		self.tableView.reloadData();
		
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var cell:UITableViewCell! = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
		
		if (cell == nil) {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell");
		}
		
		var accessory: HMAccessory = accessories[indexPath.row] as HMAccessory;
		
		cell.textLabel?.text = accessory.name;
		cell.accessoryType = UITableViewCellAccessoryType.Checkmark;
		
		return cell;
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return accessories.count;
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
