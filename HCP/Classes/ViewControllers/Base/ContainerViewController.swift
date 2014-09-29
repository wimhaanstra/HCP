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
		
		self.scrollView.backgroundColor = UIColor(white: 0.950, alpha: 1.0);
		self.scrollView.pagingEnabled = true;
		self.scrollView.showsHorizontalScrollIndicator = false;
		self.scrollView.showsVerticalScrollIndicator = false;
		self.scrollView.delegate = self;
		self.scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil);
		
		self.menuBar.showsCount = false;
		self.menuBar.delegate = self;
		self.menuBar.selectedSegmentIndex = 0;
		self.menuBar.addTarget(self, action: Selector("selectedSegment:"), forControlEvents: UIControlEvents.ValueChanged);

		self.scrollView.addSubview(roomsViewController.view);
		self.scrollView.addSubview(devicesViewController.view);
		self.devicesViewController.containerViewController = self;
		self.roomsViewController.containerViewController = self;
		
		self.menuBar.autoSetDimension(ALDimension.Height, toSize: 56);
		self.menuBar.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Bottom);
//		self.menuBar.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.view);
//		self.menuBar.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.view);

		self.scrollView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.menuBar);
		self.scrollView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top);

		self.roomsViewController.view.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.scrollView);
		self.roomsViewController.view.autoMatchDimension(ALDimension.Height, toDimension: ALDimension.Height, ofView: self.scrollView);
		self.roomsViewController.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Right);
		
		self.devicesViewController.view.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.scrollView);
		self.devicesViewController.view.autoMatchDimension(ALDimension.Height, toDimension: ALDimension.Height, ofView: self.scrollView);
		self.devicesViewController.view.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: self.roomsViewController.view)
		self.devicesViewController.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Left);
    }
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		self.roomsViewController.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration);
		self.devicesViewController.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration);
	}

	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		self.scrollView.contentOffset = CGPointMake(CGFloat(self.menuBar.selectedSegmentIndex) * self.scrollView.frame.size.width, 0);
	}
	
	func selectedSegment(menuBar: DZNSegmentedControl) -> Void {
		
		self.moveToPage(menuBar.selectedSegmentIndex, animated: true);

	}
	
	func moveToPage(page: Int, animated: Bool) {
		var viewFrame = self.scrollView.frame;
		
		viewFrame.origin.x = viewFrame.size.width * CGFloat(page);
		viewFrame.origin.y = self.menuBar.height;

		self.scrollView.scrollRectToVisible(viewFrame, animated: animated);
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
	
	deinit {
		self.scrollView.removeObserver(self, forKeyPath: "contentSize");
	}
    
}
