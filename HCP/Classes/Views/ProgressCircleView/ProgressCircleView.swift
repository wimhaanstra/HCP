//
//  ProgressCircleView.swift
//  HCP
//
//  Created by Wim Haanstra on 25/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class ProgressCircleView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame);
		self.backgroundColor = UIColor.clearColor();
	}
	
	override init() {
		super.init();
		self.backgroundColor = UIColor.clearColor();
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var value: Double = 0 {
		didSet {
			self.setNeedsDisplay();
		}
	}
	
	var color: UIColor = UIColor.whiteColor() {
		didSet {
			self.setNeedsDisplay();
		}
	}
	
	var lineWidth: CGFloat = 12 {
		didSet {
			self.setNeedsDisplay();
		}
	}
	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
		
//		[UIColor colorWithRed:0.271 green:0.192 blue:0.431 alpha:0.610]
//		[UIColor colorWithRed:0.384 green:0.274 blue:0.619 alpha:1.000]
//		[UIColor colorWithRed:0.582 green:0.410 blue:0.927 alpha:1.000]
//		[UIColor colorWithRed:0.271 green:0.091 blue:0.359 alpha:1.000]
		var disabledColor = UIColor(red: 0.271, green: 0.091, blue: 0.359, alpha: 1.0);
		
		self.drawCircleInRect(rect, color: disabledColor, percentage: 100);
		self.drawCircleInRect(rect, color: self.color, percentage: self.value);
    }
	

	func drawCircleInRect(rect: CGRect, color: UIColor, percentage: Double) {
		
		var radius: Double = Double(rect.size.width / 2) - Double(self.lineWidth / 2);
		var _value = (1.0/100.0) * ((percentage * 270) + (100 * 0) - (percentage * 0));
		var startAngle: Double = 135 * M_PI/180;
		var endAngle: Double = (135 + _value) * M_PI/180;
		var center: CGPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
		
		var ovalPattern: [CGFloat] = [1, 1, 1, 1];
		color.setStroke();
		
		var path = UIBezierPath(); //arcCenter: center, radius: 15, startAngle: startAngle, endAngle: endAngle, clockwise: false);
		path.addArcWithCenter(center, radius: CGFloat(radius), startAngle: CGFloat(135 * M_PI/180), endAngle: CGFloat(endAngle), clockwise: true);
		path.setLineDash(ovalPattern, count: 4, phase: 0);
		path.lineWidth = self.lineWidth;
		path.stroke();
		
	}
}
