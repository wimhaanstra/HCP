//
//  ContainerViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, DZNSegmentedControlDelegate, UIScrollViewDelegate {
	
	private var scrollView:UIScrollView = UIScrollView();
	private var devicesViewController: DevicesViewController = DevicesViewController();
	private var roomsViewController: RoomsViewController = RoomsViewController();
	
	private var menuBar: DZNSegmentedControl = DZNSegmentedControl(items: [ NSLocalizedString("ROOMS_TOP_MENU", comment: "Title in top menu"),  NSLocalizedString("DEVICES_TOP_MENU", comment: "Title in top menu") ]);

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.addSubview(self.scrollView);
		self.view.addSubview(self.menuBar);

		self.view.backgroundColor = UIColor.whiteColor();
		
		self.scrollView.backgroundColor = UIColor.redColor();
		self.scrollView.pagingEnabled = true;
		self.scrollView.showsHorizontalScrollIndicator = false;
		self.scrollView.showsVerticalScrollIndicator = false;
		self.scrollView.delegate = self;
		
		self.menuBar.showsCount = false;
		self.menuBar.delegate = self;
		self.menuBar.selectedSegmentIndex = 0;
		self.menuBar.addTarget(self, action: Selector("selectedSegment:"), forControlEvents: UIControlEvents.ValueChanged);

		self.menuBar.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.view);
		self.menuBar.autoSetDimension(ALDimension.Height, toSize: 56);
		self.menuBar.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.view);

		self.scrollView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.menuBar);
		self.scrollView.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self.view);
		self.scrollView.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view);
		self.scrollView.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.view);
		self.scrollView.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.view);
		
		self.scrollView.addSubview(roomsViewController.view);
		self.scrollView.addSubview(devicesViewController.view);

		self.roomsViewController.view.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.scrollView);
		self.roomsViewController.view.autoMatchDimension(ALDimension.Height, toDimension: ALDimension.Height, ofView: self.scrollView);
		self.roomsViewController.view.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.scrollView)
		self.roomsViewController.view.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.scrollView);
		
		self.devicesViewController.containerViewController = self;
		self.roomsViewController.containerViewController = self;
		
		self.devicesViewController.view.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.scrollView);
		self.devicesViewController.view.autoMatchDimension(ALDimension.Height, toDimension: ALDimension.Height, ofView: self.scrollView);
		
		self.devicesViewController.view.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: self.roomsViewController.view)
		self.devicesViewController.view.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.scrollView)
		self.devicesViewController.view.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self.scrollView)
		self.devicesViewController.view.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.scrollView);
    }
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		self.roomsViewController.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration);
		self.devicesViewController.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration);
	}
	
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		self .selectedSegment(self.menuBar);
	}
	
	func selectedSegment(menuBar: DZNSegmentedControl) -> Void {
		var viewFrame = self.scrollView.frame;
		viewFrame.origin.x = viewFrame.size.width * CGFloat(menuBar.selectedSegmentIndex);
		viewFrame.origin.y = self.menuBar.height;
		self.scrollView.scrollRectToVisible(viewFrame, animated: true);
	}
	
	func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
		return UIBarPosition.Top;
	}
	
	func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		var indexOfPage = targetContentOffset.memory.x / scrollView.frame.size.width;
		self.menuBar.selectedSegmentIndex = Int(indexOfPage);
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
