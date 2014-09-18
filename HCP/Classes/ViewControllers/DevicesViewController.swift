//
//  DevicesViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class DevicesViewController: MenuViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverControllerDelegate {

	var popOver:UIPopoverController! = nil;
	var addControllerButton: UIButton? = nil;
	private var collectionView: UICollectionView?;
	
	private var sensors: [Sensor] = [];
	
	private var availableTypes: [String] = ["Sensor", "Switch", "Dimmer", "EnergyLink", "Thermometer"];
	
    override func viewDidLoad() {
        super.viewDidLoad()

		addControllerButton = self.addButton(NSLocalizedString("CONTROLLERS_BUTTON", comment: "Button title in devices view"), width: 150, selector: Selector("popupButton_Clicked"));
		self.addButton(NSLocalizedString("REFRESH_ALL_BUTTON", comment: "Button title in devices view"), width: 150, selector: Selector("popupButton_Clicked"));
	
		/*
		for recognizer in self.tableView.gestureRecognizers as [UIGestureRecognizer] {
			if let panGesture = recognizer as? UIPanGestureRecognizer {
				panGesture.requireGestureRecognizerToFail(self.swipeDownGesture!);
			}
		}
		*/
		
		var layout = UICollectionViewFlowLayout();
		layout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
		layout.minimumInteritemSpacing = 25;
		layout.minimumLineSpacing = 25;
		layout.itemSize = CGSizeMake(220, 220);
		
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
		self.collectionView!.registerClass(SensorCell.self, forCellWithReuseIdentifier: "Sensor");
		self.collectionView!.registerClass(SwitchCell.self, forCellWithReuseIdentifier: "Switch");
		self.collectionView!.registerClass(DimmerCell.self, forCellWithReuseIdentifier: "Dimmer");
		self.collectionView!.registerClass(EnergyLinkCell.self, forCellWithReuseIdentifier: "EnergyLink");
		self.collectionView!.registerClass(ThermometerCell.self, forCellWithReuseIdentifier: "Thermometer");

		self.collectionView!.delegate = self
		self.collectionView!.dataSource = self;
		self.contentView.addSubview(self.collectionView!);
		self.collectionView!.backgroundColor = UIColor.whiteColor();
	
		var predicate = NSPredicate(format: "selected = %@", argumentArray: [ true ] );
		self.sensors = Sensor.findAllSortedBy("displayName", ascending: true, withPredicate: predicate) as [Sensor];
		//self.sensors = Sensor.findAllSortedBy("displayName", ascending: true, withPredicate: NSPredicate(format: "selected == %@", true)!);
    }
	
	override func viewDidAppear(animated: Bool) {
	}
	
	func popupButton_Clicked() {
		
		var c: HomeWizardDiscoveryViewController = HomeWizardDiscoveryViewController();
		
		var navigationController = UINavigationController(rootViewController: c);
		
		self.popOver = UIPopoverController(contentViewController: navigationController!);
		self.popOver.delegate = self;
		self.popOver.presentPopoverFromRect(addControllerButton!.frame, inView: self.view, permittedArrowDirections: .Any, animated: true);
	}
	
	func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
	
		var predicate = NSPredicate(format: "selected = %@", argumentArray: [ true ] );
		self.sensors = Sensor.findAllSortedBy("displayName", ascending: true, withPredicate: predicate) as [Sensor];
		self.collectionView!.reloadData();
		
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.sensors.count;
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		var sensor = self.sensors[indexPath.row];
		
		if (find(availableTypes, sensor.entity.name) != nil) {
			var cell = collectionView.dequeueReusableCellWithReuseIdentifier(sensor.entity.name, forIndexPath: indexPath) as SensorCell;
			cell.sensor = sensor;
			cell.cas_styleClass = sensor.entity.name;
			return cell;
		}
		else {
			var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Sensor", forIndexPath: indexPath) as SensorCell;
			cell.sensor = sensor;
			cell.cas_styleClass = "Sensor";
			return cell;
		}
		
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
