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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addControllerButton = self.addButton(NSLocalizedString("CONTROLLERS_BUTTON", comment: "Button title in devices view"), width: 150, selector: Selector("controllersButton_Clicked"));
		
		var layout = LXReorderableCollectionViewFlowLayout();
		layout.sectionInset = CollectionViewConfiguration.sharedInstance.sectionInset;
		layout.minimumInteritemSpacing = CollectionViewConfiguration.sharedInstance.interItemSpacing;
		layout.minimumLineSpacing = CollectionViewConfiguration.sharedInstance.lineSpacing;
		
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
		CollectionViewConfiguration.sharedInstance.registerCellClassesForDevices(self.collectionView!);
		
		self.collectionView!.delegate = self
		self.collectionView!.dataSource = self;
		self.contentView.addSubview(self.collectionView!);
		self.collectionView!.backgroundColor = UIColor.grayColor();
		
		self.view.backgroundColor = self.collectionView!.backgroundColor;
		
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
			self.containerViewController!.presentViewController(navigationController!, animated: true, completion: { () -> Void in
			});
			
		}
		else {
			self.popOver = UIPopoverController(contentViewController: navigationController!);
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
		
		if (find(CollectionViewConfiguration.sharedInstance.availableCellClassesForDevices, sensor.entity.name!) != nil) {
			var cell = collectionView.dequeueReusableCellWithReuseIdentifier(sensor.entity.name!, forIndexPath: indexPath) as SensorCell;
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

			var viewSize:CGSize = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? UIScreen.mainScreen().bounds.size : UIScreen.mainScreen().bounds.size; //CGRectInset(self.view.frame, 50, 50).size;
//			var viewSize:CGSize = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? self.view.frame.size : CGRectInset(self.view.frame, 50, 50).size;
			var edgeInsets = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? UIEdgeInsetsZero : UIEdgeInsetsMake(50, 50, 50, 50);
			
			self.flipToViewController(controller, fromView: cell, asChildWithSize: viewSize, withCompletion: { () -> Void in
				var transition = self.presentedFlipTransition;
				transition.edgeInsets = edgeInsets;
			});
		}
	}
	
	 func collectionView(collectionView: UICollectionView!, itemAtIndexPath fromIndexPath: NSIndexPath!, didMoveToIndexPath toIndexPath: NSIndexPath!) {
		
		ControllerManager.sharedInstance.moveSenor(fromIndexPath, toIndexPath: toIndexPath);
		self.collectionView!.reloadData();

	}
	
	func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
	{
		return CollectionViewConfiguration.sharedInstance.itemSizeForCollectionView(collectionView);
	}

	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		
		self.collectionView!.collectionViewLayout.invalidateLayout();
		self.collectionView!.reloadData();
		
	}
	
	func cellTapped(gesture: UITapGestureRecognizer) {
		
		if let sensorCell = gesture.view as? SensorCell {
			
			var sensorConfiguration = SensorConfigurationViewController();
			sensorConfiguration.sensor = sensorCell.sensor;
			
			var navigationController = UINavigationController(rootViewController: sensorConfiguration);
			
			if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
				self.containerViewController!.presentViewController(navigationController!, animated: true, completion: { () -> Void in
				});
				
			}
			else {
				self.popOver = UIPopoverController(contentViewController: navigationController!);
				self.popOver.delegate = self;
				self.popOver.presentPopoverFromRect(sensorCell.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
			}
			
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
