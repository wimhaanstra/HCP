//
//  DevicesViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class DevicesViewController: MenuViewController, LXReorderableCollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate {
	
	var popOver:UIPopoverController! = nil;
	var addControllerButton: UIButton? = nil;
	private var collectionView: UICollectionView?;
	
	var edgeOffset = 5.0;
	var itemsPerRow = 5;
	var interItemSpacing = 5.0;
	
	private var availableTypes: [String] = ["Sensor", "Switch", "Dimmer", "EnergyLink", "Thermometer", "Clock"];
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		itemsPerRow = self.numberOfItemsPerRow(UIApplication.sharedApplication().statusBarOrientation);

		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			interItemSpacing = 0;
			edgeOffset = 0;
		}
		
		addControllerButton = self.addButton(NSLocalizedString("CONTROLLERS_BUTTON", comment: "Button title in devices view"), width: 150, selector: Selector("controllersButton_Clicked"));
		self.addButton(NSLocalizedString("REFRESH_ALL_BUTTON", comment: "Button title in devices view"), width: 150, selector: Selector("controllersButton_Clicked"));
		
		
		
		var layout = LXReorderableCollectionViewFlowLayout();
		layout.sectionInset = UIEdgeInsetsMake(CGFloat(edgeOffset), CGFloat(edgeOffset), CGFloat(edgeOffset), CGFloat(edgeOffset));
		layout.minimumInteritemSpacing = CGFloat(interItemSpacing);
		layout.minimumLineSpacing = CGFloat(interItemSpacing);
//		layout.itemSize = CGSizeMake(itemSize, itemSize);
		
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
		self.collectionView!.registerClass(SensorCell.self, forCellWithReuseIdentifier: "Sensor");
		self.collectionView!.registerClass(SwitchCell.self, forCellWithReuseIdentifier: "Switch");
		self.collectionView!.registerClass(DimmerCell.self, forCellWithReuseIdentifier: "Dimmer");
		self.collectionView!.registerClass(EnergyLinkCell.self, forCellWithReuseIdentifier: "EnergyLink");
		self.collectionView!.registerClass(ThermometerCell.self, forCellWithReuseIdentifier: "Thermometer");
		self.collectionView!.registerClass(ClockCell.self, forCellWithReuseIdentifier: "Clock");
		
		self.collectionView!.delegate = self
		self.collectionView!.dataSource = self;
		self.contentView.addSubview(self.collectionView!);
		self.collectionView!.backgroundColor = UIColor.whiteColor();
		
		for recognizer in self.collectionView!.gestureRecognizers as [UIGestureRecognizer] {
			if let panGesture = recognizer as? UIPanGestureRecognizer {
				panGesture.requireGestureRecognizerToFail(self.swipeDownGesture!);
			}
		}

		self.collectionView!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero);
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
		
		self.collectionView?.reloadData();
		
		self.view.layoutIfNeeded();

	}
	
	func controllersButton_Clicked() {
		
		var c: ControllerDiscoveryViewController = ControllerDiscoveryViewController();
		var navigationController = UINavigationController(rootViewController: c);
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			self.containerViewController!.presentViewController(navigationController, animated: true, completion: { () -> Void in
			});
			
		}
		else {
			self.popOver = UIPopoverController(contentViewController: navigationController);
			self.popOver.delegate = self;
			self.popOver.presentPopoverFromRect(addControllerButton!.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
		}
		
	}
	
	func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
		//		XCGLogger.defaultInstance().info(NSStringFromCGRect(self.view.frame));
		return true;
	}
	
	func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
		//		XCGLogger.defaultInstance().info(NSStringFromCGRect(self.view.frame));
		
		self.collectionView!.reloadData();
		
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return ControllerManager.sharedInstance.allSensors().count;
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		var sensor = ControllerManager.sharedInstance.allSensors()[indexPath.row];
		
		var settingsTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cellTapped:");
		settingsTap.numberOfTouchesRequired = 2;
		
		if (find(availableTypes, sensor.entity.name) != nil) {
			var cell = collectionView.dequeueReusableCellWithReuseIdentifier(sensor.entity.name, forIndexPath: indexPath) as SensorCell;
			cell.sensor = sensor;
			cell.cas_styleClass = sensor.entity.name;
			cell.addGestureRecognizer(settingsTap);
			
			return cell;
		}
		else {
			var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Sensor", forIndexPath: indexPath) as SensorCell;
			cell.sensor = sensor;
			cell.cas_styleClass = "Sensor";
			cell.addGestureRecognizer(settingsTap);
			
			return cell;
		}
		
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var sensor = ControllerManager.sharedInstance.allSensors()[indexPath.row];
		
		//var attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath);
		var cell = collectionView.cellForItemAtIndexPath(indexPath);
		
		if (sensor.entity.name == "EnergyLink") {
			var controller = EnergyLinkDetailsViewController();
			controller.sensor = sensor;
			self.view.addSubview(controller.view);
			
			var viewSize = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? self.view.frame.size : CGRectInset(self.view.frame, 50, 50).size;
			self.flipToViewController(controller, fromView: cell, asChildWithSize: viewSize, withCompletion: { () -> Void in
			});
		}
	}
	
	 func collectionView(collectionView: UICollectionView!, itemAtIndexPath fromIndexPath: NSIndexPath!, didMoveToIndexPath toIndexPath: NSIndexPath!) {
		
		ControllerManager.sharedInstance.moveSenor(fromIndexPath, toIndexPath: toIndexPath);

		self.collectionView!.reloadData();
		/*
		var sensor = self.sensors[fromIndexPath.row];
		
		self.sensors.removeAtIndex(fromIndexPath.row);
		self.sensors.insert(sensor, atIndex: toIndexPath.row);
		
		var index = 0;
		for item in self.sensors {
			item.sortOrder = index;
			item.managedObjectContext.saveOnlySelfAndWait();
			index++;
			
			NSLog("\(item.name) with index \(index)");
		}
		
//		var predicate = NSPredicate(format: "selected = %@", argumentArray: [ true ] );
//		self.sensors = Sensor.findAllSortedBy("sortOrder", ascending: true, withPredicate: predicate) as [Sensor];
//		self.collectionView?.reloadData();*/
	}
	
	func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
	{
		var itemSize = (self.view.bounds.size.width - (2 * CGFloat(edgeOffset)) - (CGFloat(itemsPerRow) * CGFloat(edgeOffset))) / CGFloat(itemsPerRow);
		return CGSizeMake(itemSize, itemSize);
	}

	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		
		itemsPerRow = self.numberOfItemsPerRow(toInterfaceOrientation);
		self.collectionView!.collectionViewLayout.invalidateLayout();
		self.collectionView!.reloadData();
		
	}
	
	func numberOfItemsPerRow(interfaceOrientation: UIInterfaceOrientation) -> Int {
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			return (interfaceOrientation.isLandscape) ? 4 : 2;
		}
		else {
			return (interfaceOrientation.isLandscape) ? 5 : 4;
		}
		
	}
	
	func cellTapped(gesture: UITapGestureRecognizer) {
		
		if let sensorCell = gesture.view as? SensorCell {
			
			var sensorConfiguration = SensorConfigurationViewController();
			sensorConfiguration.sensor = sensorCell.sensor;
			
			var navigationController = UINavigationController(rootViewController: sensorConfiguration);
			
			self.popOver = UIPopoverController(contentViewController: navigationController);
			self.popOver.delegate = self;
			self.popOver.presentPopoverFromRect(sensorCell.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
			
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
