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
	
//	var log = XCGLogger.defaultInstance()
	var window: UIWindow?
	var containerViewController: ContainerViewController?

	func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {

//		log.setup(logLevel: .Debug, showLogLevel: false, showFileNames: true, showLineNumbers: true, writeToFile: nil);
		
		CASStyler.defaultStyler().filePath = NSBundle.mainBundle().pathForResource("Default", ofType: "css");
		//CASStyler.defaultStyler().watchFilePath = "/Volumes/Projects/HCP/HCP/Resources/Stylesheets/Default/Default.css";
		
		MagicalRecord.setupAutoMigratingCoreDataStack();
		MagicalRecord.setLoggingLevel(MagicalRecordLoggingLevel.Verbose);

		ControllerManager.sharedInstance.all();
		
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds);
		self.containerViewController = ContainerViewController();
		self.window?.rootViewController = self.containerViewController;
		self.window?.makeKeyAndVisible();
		
//		println(NSTimeZone.knownTimeZoneNames());
		
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

