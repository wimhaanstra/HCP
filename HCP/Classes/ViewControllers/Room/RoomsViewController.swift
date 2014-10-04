//
//  RoomsViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class RoomsViewController: MenuViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var collectionView: UICollectionView?;
	var addRoomButton: UIButton?;
	private var roomNameTextField: UITextField? = nil;
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		addRoomButton = self.addButton(NSLocalizedString("ADD_ROOM_BUTTON", comment: "Button title in rooms view"), width: 150, selector: Selector("addRoom_Clicked"));

		var layout = UICollectionViewFlowLayout();
		layout.sectionInset = CollectionViewConfiguration.sharedInstance.sectionInset;
		layout.minimumInteritemSpacing = CollectionViewConfiguration.sharedInstance.interItemSpacing;
		layout.minimumLineSpacing = CollectionViewConfiguration.sharedInstance.lineSpacing;
		
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
		self.collectionView!.registerClass(RoomCell.self, forCellWithReuseIdentifier: "base");
		self.collectionView!.delegate = self
		self.collectionView!.dataSource = self;
		self.collectionView!.backgroundColor = UIColor.whiteColor();
		self.contentView.addSubview(self.collectionView!);
		
		self.collectionView!.backgroundColor = UIColor.grayColor();
		
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
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Room.findAllSortedBy("order", ascending: true).count;
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		var cell = collectionView.dequeueReusableCellWithReuseIdentifier("base", forIndexPath: indexPath) as RoomCell;

		cell.cas_styleClass = "Room";
		var room = Room.findAllSortedBy("order", ascending: true)[indexPath.row] as Room;
		cell.room = room;
		return cell;
		
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		var cell = collectionView.cellForItemAtIndexPath(indexPath);

		var room = Room.findAllSortedBy("order", ascending: true)[indexPath.row] as Room;
		
		var controller = RoomViewController();
		controller.containerViewController = self.containerViewController;
		controller.room = room;
		self.view.addSubview(controller.view);
		
		var viewSize:CGSize = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? UIScreen.mainScreen().bounds.size : UIScreen.mainScreen().bounds.size; //CGRectInset(self.view.frame, 50, 50).size;
		var edgeInsets = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? UIEdgeInsetsZero : UIEdgeInsetsZero; //UIEdgeInsetsMake(50, 50, 50, 50);
		
		self.flipToViewController(controller, fromView: cell, asChildWithSize: viewSize, withCompletion: { () -> Void in
			var transition = self.presentedFlipTransition;
			transition.edgeInsets = edgeInsets;
		});
	
	}
	
	func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
	{
		return CollectionViewConfiguration.sharedInstance.itemSizeForCollectionView(collectionView);
	}
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		self.collectionView!.collectionViewLayout.invalidateLayout();
		self.collectionView!.reloadData();
	}


	
	func addRoom_Clicked() {
		var alert = UIAlertController(title: NSLocalizedString("ADD_ROOM_ALERT_TITLE",
			comment: "Add room alert title"),
			message: NSLocalizedString("ADD_ROOM_ALERT_TEXT", comment: "Add room alert text"),
			preferredStyle: UIAlertControllerStyle.Alert);
		
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = NSLocalizedString("ADD_ROOM_ALERT_PLACEHOLDER", comment: "Add room alert placeholder");
			textField.autocapitalizationType = .Words;
			self.roomNameTextField = textField;
		});
		
		
		alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_OK", comment: "Alert OK button"), style: UIAlertActionStyle.Default, handler: { (action) -> Void in
			
			if (self.roomNameTextField == nil || self.roomNameTextField?.text! == "") {
				return;
			}
			
			var roomName: String = self.roomNameTextField!.text;

			MagicalRecord.saveWithBlock({ (context) -> Void in
				
				var newRoom = Room.createEntityInContext(context) as Room;
				newRoom.name = roomName;
				
			}, completion: { (success, error) -> Void in
				
				self.collectionView!.reloadData();
				
			});
			
		}));
		
		alert.addAction(UIAlertAction(title: NSLocalizedString("ALERT_CANCEL", comment: "Alert Cancel button"), style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
		}));
		
		self.presentViewController(alert, animated: true, completion: { () -> Void in
		});
	}
}
