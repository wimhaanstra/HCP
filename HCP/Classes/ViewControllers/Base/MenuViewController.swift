//
//  MenuViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 12/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
	
	var containerViewController: UIViewController?;

	var swipeDownGesture: UISwipeGestureRecognizer? = nil;
	var tapGesture: UITapGestureRecognizer? = nil;
	var menuBar: UIView = UIView();
	
	var contentView: UIView = UIView();

	var blurView: UIView = UIView();
	
	var menuVisible: Bool = false;
	let menuHeight: CGFloat = 40.0;
	
	var menuBarHeightConstraint: NSLayoutConstraint?;
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.whiteColor();

		self.swipeDownGesture = UISwipeGestureRecognizer(target: self, action: Selector("menuViewSwipedDown"));
		self.swipeDownGesture?.direction = UISwipeGestureRecognizerDirection.Down;
		self.swipeDownGesture?.numberOfTouchesRequired = 2;
		self.view.addGestureRecognizer(self.swipeDownGesture!);
		
		self.tapGesture = UITapGestureRecognizer(target: self, action: Selector("menuViewTapped"));
		self.tapGesture?.numberOfTouchesRequired = 1;
		
		self.menuBar.userInteractionEnabled = true;
		self.menuBar.cas_styleClass = "MenuBar";
		self.menuBar.clipsToBounds = true;
		
		self.view.addSubview(self.menuBar);
		self.view.addSubview(self.contentView);
		
		self.menuBar.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Bottom);
		
//		self.menuBar.autoMatchDimension(ALDimension.Width, toDimension: ALDimension.Width, ofView: self.view);
//		self.menuBar.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.view);
//		self.menuBar.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view);
		menuBarHeightConstraint = self.menuBar.autoSetDimension(ALDimension.Height, toSize: 0);
		
		self.contentView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero, excludingEdge: ALEdge.Top);
		self.contentView.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.menuBar);
		
		self.blurView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3);
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
		
		self.view.layoutIfNeeded();
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated);
		self.view.layoutIfNeeded();
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
			self.blurView.alpha = 0;
			
			self.contentView.addSubview(self.blurView);
			self.blurView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsZero);

			UIView.animateWithDuration(0.2, animations: { () -> Void in
				self.blurView.alpha = 1;

				self.menuBarHeightConstraint?.constant = self.menuHeight;
				
				self.view.layoutIfNeeded();
				self.view.addGestureRecognizer(self.tapGesture!);
			});
		}
	}
	
	func closeMenu() {
		
		if (self.menuVisible) {
			self.menuVisible = false;
			
			UIView.animateWithDuration(0.2, animations: { () -> Void in
				self.menuBarHeightConstraint?.constant = 0;
				self.blurView.alpha = 0;
				self.view.layoutIfNeeded();

			}, completion: { (complete) -> Void in
				self.view.removeGestureRecognizer(self.tapGesture!);
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
