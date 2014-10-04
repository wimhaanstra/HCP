//
//  CollectionViewConfiguration.swift
//  HCP
//
//  Created by Wim Haanstra on 29/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class CollectionViewConfiguration {
	
	class var sharedInstance : CollectionViewConfiguration {
		struct Static {
			static let instance: CollectionViewConfiguration = CollectionViewConfiguration();
		}
		
		return Static.instance;
	}
	
	var edgeOffset: CGFloat {
		get {
			return (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? 3 : 5.0;
		}
	}
	
	var sectionInset: UIEdgeInsets {
		get {
			return UIEdgeInsetsMake(self.edgeOffset, self.edgeOffset, self.edgeOffset, self.edgeOffset);
		}
	}
	
	var lineSpacing: CGFloat {
		get {
			return (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? 5 : 5.0;
		}
	}
	
	var interItemSpacing: CGFloat {
		get {
			return (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? 0 : 5.0;
		}
	}
	
	var availableCellClassesForDevices: [String] = ["Sensor", "Switch", "Dimmer", "EnergyLink", "Thermometer", "Clock", "Weather"];
	
	func itemsPerRow(interfaceOrientation: UIInterfaceOrientation) -> Int {
		if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
			return (interfaceOrientation.isLandscape) ? 5 : 3;
		}
		else {
			return (interfaceOrientation.isLandscape) ? 5 : 4;
		}
	}
	
	func itemSizeForCollectionView(collectionView: UICollectionView) -> CGSize {
		var itemSize = (collectionView.bounds.size.width - (2 * self.edgeOffset) - (CGFloat(self.itemsPerRow(UIApplication.sharedApplication().statusBarOrientation)) * self.edgeOffset)) / CGFloat(self.itemsPerRow(UIApplication.sharedApplication().statusBarOrientation));
		return CGSizeMake(itemSize, itemSize);
	}
	
	func registerCellClassesForDevices(collectionView: UICollectionView) {
		collectionView.registerClass(SensorCell.self, forCellWithReuseIdentifier: "Sensor");
		collectionView.registerClass(SwitchCell.self, forCellWithReuseIdentifier: "Switch");
		collectionView.registerClass(DimmerCell.self, forCellWithReuseIdentifier: "Dimmer");
		collectionView.registerClass(EnergyLinkCell.self, forCellWithReuseIdentifier: "EnergyLink");
		collectionView.registerClass(ThermometerCell.self, forCellWithReuseIdentifier: "Thermometer");
		collectionView.registerClass(ClockCell.self, forCellWithReuseIdentifier: "Clock");
		collectionView.registerClass(WeatherCell.self, forCellWithReuseIdentifier: "Weather");
	}
	

	
}
