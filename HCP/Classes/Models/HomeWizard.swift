@objc(HomeWizard)
class HomeWizard: _HomeWizard {
	
	private var _fetchDataTimer: NSTimer? = nil;
	private var _fetchSensorsTimer: NSTimer? = nil;
    
    override class func discover(includeStored: Bool, completion: (results: [Controller]) -> Void) {
        
        let discoveryUrl = "http://gateway.homewizard.nl/discovery.php";
		
		XCGLogger.defaultInstance().info("HomeWizard Discovery: " + discoveryUrl);
		
        let manager = AFHTTPRequestOperationManager();
        
        manager.GET(discoveryUrl, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
				
				if (responseObject.objectForKey("status") as String == "ok") {
					var ipAddress = responseObject.objectForKey("ip") as String
					var match: AnyObject! = HomeWizard.findFirstByAttribute("ip", withValue: ipAddress);
					
					if (match == nil) {
						
						XCGLogger.defaultInstance().info("Discovered HomeWizard not yet in database (" + ipAddress + ")");
						
						var foundObject: HomeWizard = HomeWizard.createEntityInContext(nil) as HomeWizard;
						foundObject.ip = ipAddress;
						foundObject.name = ipAddress;
						foundObject.lastUpdate = NSDate();
						completion(results: [foundObject]);
					}
					else {
						
						XCGLogger.defaultInstance().info("Discovered HomeWizard is already in database (" + ipAddress + ")");
						
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
                XCGLogger.defaultInstance().info("Error: " + error.localizedDescription)
            }
        )
    }
	
	override var entityName: String {
		return "HomeWizard";
	}

	
	func password() -> String? {
		return UICKeyChainStore.stringForKey(self.ip! + ".password");
	}
    
	func performAction(command: String, completion: (results: AnyObject!, error: NSError?) -> Void ) -> Void {
		XCGLogger.defaultInstance().info("Performing HomeWizard Command: " + command + " (" + self.ip! + ")");
		
		if (self.password() != nil) {
			let url = "http://" + self.ip! + "/" + self.password()! + command;
			
			let manager = AFHTTPRequestOperationManager();
			manager.GET(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
				completion(results: responseObject, error: nil);
			},
			failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
				completion(results: nil, error: error);
			});
		}
    }
	
	func login(password: String, completion: (success: Bool) -> Void) -> Void {

		var stored = UICKeyChainStore.setString(password, forKey: self.ip! + ".password");
		if (!stored) {
			XCGLogger.defaultInstance().info("Storing value in keychain failed");
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
		
		XCGLogger.defaultInstance().info("Fetching sensors");
		
		
		self.performAction("/get-sensors", completion: { (results, error) -> Void in
			if (results != nil && results.objectForKey("response") != nil) {
				if let response = results.objectForKey("response") as? Dictionary<String, AnyObject> {
					self.parse(response);
				}
			}
	
			// When done, start updating data (again)
			if (self._fetchDataTimer == nil) {
				self._fetchDataTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: true);
			}
		});
		
		
	}
	
	func fetchData() {
		self.performAction("/get-status", completion: { (results, error) -> Void in
			
			if (results != nil && results.objectForKey("response") != nil) {
				if let response = results.objectForKey("response") as? Dictionary<String, AnyObject> {
					self.parse(response);
				}
			}
			if (self._fetchDataTimer == nil) {
				self._fetchDataTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: true);
			}
		});

	}
	
	override func start() {
		
		if (self.managedObjectContext == nil) {
			XCGLogger.defaultInstance().error("This object is not saved, you cannot store sensors for this device.");
			return;
		}
		
		_fetchSensorsTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("fetchSensors"), userInfo: nil, repeats: true);
		
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
	
}
