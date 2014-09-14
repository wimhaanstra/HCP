//
//  AppDelegate.swift
//  HCP
//
//  Created by Wim Haanstra on 19/08/14.
//  Copyright (c) 2014 Wim Haanstra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	var containerViewController: ContainerViewController?


	func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

		
		CASStyler.defaultStyler().filePath = NSBundle.mainBundle().pathForResource("Default", ofType: "css");
		CASStyler.defaultStyler().watchFilePath = "/Volumes/Projects/HCP/HCP/Resources/Stylesheets/Default/Default.css";
		
		DDLog.addLogger(DDASLLogger.sharedInstance())
		
		DDTTYLogger.sharedInstance().colorsEnabled = true;

		DDTTYLogger.sharedInstance().setForegroundColor(UIColor.yellowColor(), backgroundColor: nil, forFlag: LOG_FLAG_DEBUG);
		DDTTYLogger.sharedInstance().setForegroundColor(UIColor.grayColor(), backgroundColor: nil, forFlag: LOG_FLAG_VERBOSE);
		DDTTYLogger.sharedInstance().setForegroundColor(UIColor.blackColor(), backgroundColor: nil, forFlag: LOG_FLAG_INFO);
		DDTTYLogger.sharedInstance().setForegroundColor(UIColor.redColor(), backgroundColor: nil, forFlag: LOG_FLAG_ERROR);
		DDTTYLogger.sharedInstance().setForegroundColor(UIColor.purpleColor(), backgroundColor: nil, forFlag: LOG_FLAG_WARN);

		DDTTYLogger.sharedInstance().setLogFormatter(ExtendedLogFormatter());
		DDLog.addLogger(DDTTYLogger.sharedInstance())
		DDLog.logLevel = .Verbose;
		DDLog.logAsync = false;

		MagicalRecord.setupAutoMigratingCoreDataStack();
		MagicalRecord.setLoggingLevel(MagicalRecordLoggingLevel.Verbose);

		ControllerManager.sharedInstance.allHomeWizards();
		
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds);
		self.containerViewController = ContainerViewController();
		self.window?.rootViewController = self.containerViewController;
		self.window?.makeKeyAndVisible();
		
		return true
	}

	func applicationWillResignActive(application: UIApplication!) {
	}

	func applicationDidEnterBackground(application: UIApplication!) {
	}

	func applicationWillEnterForeground(application: UIApplication!) {
	}

	func applicationDidBecomeActive(application: UIApplication!) {
	}

	func applicationWillTerminate(application: UIApplication!) {
		ControllerManager.sharedInstance.stopControllers();
		MagicalRecord.cleanUp();
	}

}

