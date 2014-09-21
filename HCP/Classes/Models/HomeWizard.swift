@objc(HomeWizard)
class HomeWizard: _HomeWizard {
	
	private var _fetchDataTimer: NSTimer? = nil;
	private var _fetchSensorsTimer: NSTimer? = nil;
	
	override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
		
		let discoveryUrl = "http://gateway.homewizard.nl/discovery.php";
		
		NSLog("HomeWizard Discovery: " + discoveryUrl);
		
		let manager = AFHTTPRequestOperationManager();
		
		manager.GET(discoveryUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
			
			let responseDict = responseObject as Dictionary<String, AnyObject>
			
			let status: String? = (responseDict["status"] as AnyObject?) as? String;
			let ip: String? = (responseDict["ip"] as AnyObject?) as? String;
			
			if (status != nil && status == "ok" && ip != nil && ip != "") {
				
				var ipAddress = responseObject.objectForKey("ip") as String
				var match: AnyObject! = HomeWizard.findFirstByAttribute("ip", withValue: ipAddress);
				
				if (match == nil) {
					
					NSLog("Discovered HomeWizard not yet in database (" + ipAddress + ")");
					
					var foundObject: HomeWizard = HomeWizard.createEntityInContext(nil) as HomeWizard;
					foundObject.ip = ipAddress;
					foundObject.name = "HomeWizard (\(ipAddress))";
					foundObject.type = kControllerType.HomeWizard;
					foundObject.lastUpdate = NSDate();
					foundObject.dataRefreshInterval = 5;
					foundObject.sensorRefreshInterval = 30;
					completion(results: [foundObject]);
				}
				else {
					
					NSLog("Discovered HomeWizard is already in database (" + ipAddress + ")");
					
					if  (includeStored) {
						var foundObject: HomeWizard = match as HomeWizard
						completion(results: [foundObject])
					}
					else {
						completion(results: []);
					}
				}
				
			}
			else {
				completion(results: []);
			}
			},
			failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
				NSLog("Error: " + error.localizedDescription)
			}
		)
	}
	
	override var entityName: String {
		return "HomeWizard";
	}
	
	override var description: String {
		return "HomeWizard (" + self.ip! + ")";
	}
	
	func password() -> String? {
		return UICKeyChainStore.stringForKey(self.ip! + ".password");
	}
	
	func available() -> Bool {
		
		let url = "http://" + self.ip! + "/";
		
		var request = NSMutableURLRequest(URL: NSURL(string: url));
		request.HTTPMethod = "HEAD";
		request.timeoutInterval = 2.0;
		var response: NSURLResponse?;
		var error: NSError?;
		
		NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error);
		println(error);
		return (error == nil) ? true : false;
		
	}
	
	func performAction(command: String, completion: (results: AnyObject!, error: NSError?) -> Void ) -> Void {
		NSLog("Performing HomeWizard Command: " + command + " (" + self.ip! + ")");
		
		if (self.password() != nil) {
			
			let url = "http://" + self.ip! + "/" + self.password()! + command;
			
			let manager = AFHTTPRequestOperationManager();
			
			manager.GET(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
					completion(results: responseObject, error: nil);
				},
				failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
					NSLog(error.localizedDescription);
					completion(results: nil, error: error);
			});
		}
	}
	
	func login(password: String, completion: (success: Bool) -> Void) -> Void {
		
		var stored = UICKeyChainStore.setString(password, forKey: self.ip! + ".password");
		if (!stored) {
			//			NSLog("Storing value in keychain failed");
		}
		
		self.performAction("/enlist", completion: { (results, error) -> Void in
			if (error != nil) {
				completion(success: false);
			}
			else {
				if (results.objectForKey("status") != nil) {
					var status: String = results.objectForKey("status") as String;
					completion(success: (status == "ok"));
				}
				else {
					completion(success: false);
				}
			}
		})
	}
	
	func fetchSensors() {
		
		// Disable data fetch, to make sure that values don't overwrite eachother
		if (_fetchDataTimer != nil) {
			_fetchDataTimer?.invalidate();
			_fetchDataTimer = nil;
		}
		
		if (_fetchSensorsTimer != nil) {
			_fetchSensorsTimer?.invalidate();
			_fetchSensorsTimer = nil;
		}
		
		self.performAction("/get-sensors", completion: { (results, error) -> Void in
			if (error == nil && results != nil && results.objectForKey("response") != nil) {
				if let response = results.objectForKey("response") as? Dictionary<String, AnyObject> {
					self.parse(response);
				}
				
				// When done, start updating data (again)
				if (self._fetchDataTimer == nil) {
					self._fetchDataTimer = NSTimer.scheduledTimerWithTimeInterval(self.dataRefreshInterval!, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: false);
				}
			}
			
			self._fetchSensorsTimer = NSTimer.scheduledTimerWithTimeInterval(self.sensorRefreshInterval!,
				target: self,
				selector: Selector("fetchSensors"),
				userInfo: nil,
				repeats: false);
		});
	}
	
	func fetchData() {
		self.performAction("/get-status", completion: { (results, error) -> Void in
			
			if (results != nil && results.objectForKey("response") != nil) {
				if let response = results.objectForKey("response") as? Dictionary<String, AnyObject> {
					self.parse(response);
				}
			}
			
			self._fetchDataTimer = NSTimer.scheduledTimerWithTimeInterval(self.dataRefreshInterval!, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: false);
		});
		
	}
	
	override func start() {
		
		if (self.managedObjectContext == nil) {
			//			XCGLogger.defaultInstance().error("This object is not saved, you cannot store sensors for this device.");
			return;
		}
		
		self._fetchSensorsTimer = NSTimer.scheduledTimerWithTimeInterval(
			self.sensorRefreshInterval!,
			target: self,
			selector: Selector("fetchSensors"),
			userInfo: nil,
			repeats: false
		);
		
		self.started = true;
		
		// Because we don't want to wait for the timer to trigger, call fetchSensors now also
		self.fetchSensors();
	}
	
	override func stop() {
		
		self.started = false;
		
		if (_fetchDataTimer != nil) {
			_fetchDataTimer?.invalidate();
			_fetchDataTimer = nil;
		}
		
		if (_fetchSensorsTimer != nil) {
			_fetchSensorsTimer?.invalidate();
			_fetchSensorsTimer = nil;
		}
		
	}
	
	func parse(response: Dictionary<String, AnyObject>) {
		if let switches = response["switches"] as? NSArray {
			for item in switches {
				var itemDictionary: NSDictionary = item as NSDictionary;
				
				if (itemDictionary.objectForKey("id") == nil) {
					continue;
				}
				
				var id = itemDictionary.objectForKey("id") as Int;
				
				if let switchType = itemDictionary.objectForKey("type") as? String {
					if (switchType == "switch") {
						EntityFactory<Switch>.create(self, definition: itemDictionary);
					}
					else if (switchType == "dimmer") {
						EntityFactory<Dimmer>.create(self, definition: itemDictionary);
					}
					else if (switchType == "hue") {
						// TODO: Add Hue via HomeWizard support
					}
					else if (switchType == "asun") {
						EntityFactory<Asun>.create(self, definition: itemDictionary);
					}
				}
			}
		}
		
		if let thermometers = response["thermometers"] as? NSArray {
			for item in thermometers {
				var itemDictionary: NSDictionary = item as NSDictionary;
				
				if (itemDictionary.objectForKey("id") == nil) {
					continue;
				}
				
				var e = EntityFactory<Thermometer>.create(self, definition: itemDictionary);
			}
		}
		
		
		if let energyLinks = response["energylinks"] as? NSArray {
			for item in energyLinks {
				var itemDictionary: NSDictionary = item as NSDictionary;
				
				if (itemDictionary.objectForKey("id") == nil) {
					continue;
				}
				
				var e = EntityFactory<EnergyLink>.create(self, definition: itemDictionary);
			}
		}
		
	}
	
	override func fields() -> [AnyObject]! {
		
		var superFields = super.fields();
		superFields.append([ "key": "dataRefreshInterval", "title": "Sensor data refresh rate", "type": "number" ]);
		superFields.append([ "key": "sensorRefreshInterval", "title": "Sensor inventory refresh rate", "type": "number" ]);
		return superFields;
		
	}
	
	
}
