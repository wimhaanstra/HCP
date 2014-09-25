//
//  EnergyLinkDetailsViewController.swift
//  HCP
//
//  Created by Wim Haanstra on 21/09/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

class EnergyLinkDetailsViewController: SensorDetailsViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated);
		self.view.backgroundColor = UIColor(red: 0.341, green: 0.273, blue: 0.502, alpha: 1.0);
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
