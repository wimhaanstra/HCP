//
//  RoomViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 26/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class RoomViewController: MenuViewController, UIPopoverControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var closeButton: UIButton = UIButton.buttonWithType(.Custom) as UIButton;
	var textLabel: UILabel = UILabel();
	var popOver:UIPopoverController? = nil;
	var addSensorButton: UIButton = UIButton.buttonWithType(.Custom) as UIButton;
	var collectionView: UICollectionView?;
	
	var room: Room? {
		didSet {
			if (self.room != nil) {
				self.textLabel.text = self.room!.name!.uppercaseString
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		addSensorButton = self.addButton(NSLocalizedString("ADD_SENSOR_BUTTON", comment: "Button title in room view"), width: 150, selector: Selector("addSensorButton_Clicked"));
		
		var layout = LXReorderableCollectionViewFlowLayout();
		layout.sectionInset = CollectionViewConfiguration.sharedInstance.sectionInset;
		layout.minimumInteritemSpacing = CollectionViewConfiguration.sharedInstance.interItemSpacing;
		layout.minimumLineSpacing = CollectionViewConfiguration.sharedInstance.lineSpacing;
		
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
		CollectionViewConfiguration.sharedInstance.registerCellClassesForDevices(self.collectionView!);
		
		self.collectionView!.delegate = self
		self.collectionView!.dataSource = self;
		self.contentView.addSubview(self.collectionView!);
		self.collectionView!.backgroundColor = UIColor.whiteColor();
		
		for recognizer in self.collectionView!.gestureRecognizers as [UIGestureRecognizer] {
			if let panGesture = recognizer as? UIPanGestureRecognizer {
				panGesture.requireGestureRecognizerToFail(self.swipeDownGesture!);
			}
		}
		
		self.view.backgroundColor = UIColor.grayColor();
		self.collectionView!.backgroundColor = self.view.backgroundColor;
		
		self.textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 42);
		self.textLabel.textColor = UIColor.whiteColor();
		self.textLabel.adjustsFontSizeToFitWidth = true;
		self.textLabel.alpha = 0.3;
		self.contentView.addSubview(self.textLabel);

		self.closeButton.setTitle("Close", forState: UIControlState.Normal);
		self.closeButton.addTarget(self, action: Selector("closeButton_Clicked"), forControlEvents: UIControlEvents.TouchUpInside);
		self.closeButton.alpha = 0.3;
		self.closeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 24);
		self.contentView.addSubview(self.closeButton);
		
		self.closeButton.autoSetDimensionsToSize(CGSizeMake(90, 44));
		self.closeButton.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5);
		self.closeButton.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 5);

		self.textLabel.autoSetDimension(ALDimension.Height, toSize: 44);
		self.textLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 5);
		self.textLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 5);
		self.textLabel.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Left, ofView: self.closeButton, withOffset: 5);
		
		self.collectionView!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top);
		self.collectionView!.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.closeButton);
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("orientationDidChange:"), name: UIDeviceOrientationDidChangeNotification, object: nil);

    }
	
	override func viewWillAppear(animated: Bool) {
		
		self.collectionView!.reloadData();
	}
	
	override func viewDidAppear(animated: Bool) {
	
		
	}
	
	func addSensorButton_Clicked() {
		
		var c: RoomAddSensorViewController = RoomAddSensorViewController();
		c.room = self.room!;
		var navigationController = UINavigationController(rootViewController: c);
		
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			self.containerViewController!.presentViewController(navigationController!, animated: true, completion: { () -> Void in
			});
			
		}
		else {
			self.popOver = UIPopoverController(contentViewController: navigationController!);
			self.popOver!.delegate = self;
			self.popOver!.presentPopoverFromRect(addSensorButton.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
		}
		
	}
	
	func closeButton_Clicked() {
		self.dismissFlipWithCompletion { () -> Void in
		}
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (self.room != nil) ? self.room!.sensors.count : 0;
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		var sensor = self.room!.sensors.allObjects[indexPath.row] as Sensor;
		
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
	
	func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
	{
		return CollectionViewConfiguration.sharedInstance.itemSizeForCollectionView(collectionView);
	}
	
	func orientationDidChange(notification: NSNotification) {
		self.collectionView!.collectionViewLayout.invalidateLayout();
		self.collectionView!.reloadData();
	}
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		self.collectionView!.collectionViewLayout.invalidateLayout();
		self.collectionView!.reloadData();
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil);
	}
}
