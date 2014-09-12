//
//  ContainerViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
	
	private var scrollView:UIScrollView = UIScrollView();
	private var devicesViewController: DevicesViewController = DevicesViewController();
	private var roomsViewController: RoomsViewController = RoomsViewController();

    override func viewDidLoad() {
        super.viewDidLoad()

		self.scrollView.frame = self.view.bounds;
		self.scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
		self.scrollView.pagingEnabled = true;
		
		self.view.addSubview(scrollView);
    }
	
	override func viewDidAppear(animated: Bool) {
	
		self.view.backgroundColor = UIColor.whiteColor();
		
		self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height);
		
		self.roomsViewController.view.frame = self.view.bounds;
		self.devicesViewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.size.width, 0);
		
		self.scrollView.addSubview(roomsViewController.view);
		self.scrollView.addSubview(devicesViewController.view);
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
