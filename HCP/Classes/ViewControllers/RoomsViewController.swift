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
	private var roomNameTextField: UITextField? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
		
		var addRoomButton = self.addButton("Add Room", width: 150, selector: Selector("addRoom_Clicked"));

		/*
UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
layout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
layout.minimumInteritemSpacing = 25;
layout.minimumLineSpacing = 25;
		*/

		var layout = UICollectionViewFlowLayout();
		layout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
		layout.minimumInteritemSpacing = 25;
		layout.minimumLineSpacing = 25;
		layout.itemSize = CGSizeMake(220, 220);
		
		self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout);
		self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "base");
		self.collectionView!.delegate = self
		self.collectionView!.dataSource = self;
		self.contentView.addSubview(self.collectionView!);
		self.collectionView!.backgroundColor = UIColor.whiteColor();
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Room.findAllSortedBy("order", ascending: true).count;
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		var cell = collectionView.dequeueReusableCellWithReuseIdentifier("base", forIndexPath: indexPath) as UICollectionViewCell;
		
		cell.cas_styleClass = "Room";
		var room = Room.findAllSortedBy("order", ascending: true)[indexPath.row] as Room;
		
		var label = UILabel(frame: CGRectMake(5, cell.frame.size.height - 35, cell.frame.size.width - 10, 30));
		label.font = UIFont(name: "HelveticaNeue-Thin", size: 30);
		cell.contentView.addSubview(label);
		cell.layer.cornerRadius = 5;
		
		label.text = room.name;
		
		return cell;
		
	}
	
	func addRoom_Clicked() {
		var alert = UIAlertController(title: "Room name", message: "Please give your new room a name", preferredStyle: UIAlertControllerStyle.Alert);
		alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
			textField.placeholder = "Room name";
			self.roomNameTextField = textField;
		});
		
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
			
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
		
		self.presentViewController(alert, animated: true, completion: { () -> Void in
			
		});	}

}
