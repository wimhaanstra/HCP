//
//  MenuViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

	var swipeDownGesture: UISwipeGestureRecognizer? = nil;
	var tapGesture: UITapGestureRecognizer? = nil;
	var menuBar: UIView = UIView();
	
	var contentView: UIView = UIView();

	var blurView: UIView = UIView();
	var menuVisible: Bool = false;
	let menuHeight: CGFloat = 40.0;
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor();

		self.swipeDownGesture = UISwipeGestureRecognizer(target: self, action: Selector("menuViewSwipedDown"));
		self.swipeDownGesture?.direction = UISwipeGestureRecognizerDirection.Down;
		self.swipeDownGesture?.numberOfTouchesRequired = 2;
		self.view.addGestureRecognizer(self.swipeDownGesture!);
		
		self.tapGesture = UITapGestureRecognizer(target: self, action: Selector("menuViewTapped"));
		self.tapGesture?.numberOfTouchesRequired = 2;
		self.view.addGestureRecognizer(self.tapGesture!);
		
		self.menuBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
		self.menuBar.userInteractionEnabled = true;
		self.menuBar.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleBottomMargin;
		self.menuBar.cas_styleClass = "MenuBar";
		self.menuBar.clipsToBounds = true;
		self.view.addSubview(self.menuBar);
		
		self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
		self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
		self.view.addSubview(self.contentView);
		
		self.blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
		self.blurView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3);
    }
	
	override func viewDidAppear(animated: Bool) {
		
		super.viewDidAppear(animated);
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func menuViewSwipedDown() {

		self.openMenu();
	}
	
	func menuViewTapped() {
		
		self.closeMenu();
		
	}
	
	func openMenu() {

		if (!self.menuVisible) {
			self.menuVisible = true;
			self.blurView.frame = self.contentView.frame;
			self.blurView.alpha = 0;

			UIView.animateWithDuration(0.2, animations: { () -> Void in
				self.blurView.alpha = 1;
				self.menuBar.frame = CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight);
				self.contentView.frame = CGRectOffset(self.contentView.frame, 0, self.menuHeight);
				self.contentView.addSubview(self.blurView);
			});
		}
	}
	
	func closeMenu() {
		
		if (self.menuVisible) {
			self.menuVisible = false;
			
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				self.menuBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
				self.contentView.frame = CGRectOffset(self.contentView.frame, 0, -1 * self.menuHeight);
				self.blurView.alpha = 0;
			}, completion: { (complete) -> Void in
				self.blurView.removeFromSuperview();
			});
			
		}
		
	}
	
	func addButton(title: String, width: CGFloat, selector: Selector) -> UIButton {
		
		var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
		
		button.frame = CGRectMake(findLastButtonPosition(), 0, width, self.menuHeight);
		button.setTitle(title, forState: UIControlState.Normal);
		button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
		button.addTarget(self, action: selector, forControlEvents: UIControlEvents.TouchUpInside);
		self.menuBar.addSubview(button);
		
		return button;
		
	}
	
	func findLastButtonPosition() -> CGFloat {
		
		var returnValue: CGFloat = 0;
		
		for item in self.menuBar.subviews as [UIView] {
			if let button = item as? UIButton {
				
				var x = button.frame.size.width + button.frame.origin.x;
				if (x > returnValue) {
					returnValue = x;
				}
				
			}
		}
		
		return returnValue;
		
	}
}
