@objc(EnergyLink)
class EnergyLink: _EnergyLink {
	
	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let tariffValue = definition.objectForKey("tariff") as? Int {
			self.tariff = tariffValue;
		}
		
		if let t1Value = definition.objectForKey("t1") as? String {
			self.t1 = t1Value;
		}
		
		if let t2Value = definition.objectForKey("t2") as? String {
			self.t2 = t2Value;
		}
		
		if let usedValue = definition.objectForKey("used") as? NSDictionary {
			self.used = CombinedValue(itemDictionary: usedValue);
		}
		
		if let aggregateValue = definition.objectForKey("aggregate") as? NSDictionary {
			self.aggregate = CombinedValue(itemDictionary: aggregateValue);
		}
		
		if let gasValue = definition.objectForKey("gas") as? NSDictionary {
			self.gas = CombinedValue(itemDictionary: gasValue);
		}
		
		if let s1Value = definition.objectForKey("s1") as? NSDictionary {
			self.s1 = CombinedValue(itemDictionary: s1Value);
		}
		
		if let s2Value = definition.objectForKey("s2") as? NSDictionary {
			self.s2 = CombinedValue(itemDictionary: s2Value);
		}
		
	}
	
	func getGraphValues(graphResolution: kGraphResolution, completion: (results: [GraphValue]) -> Void ) -> Void {
		
		var resolution = graphResolution.stringValue();
		
		(self.controller! as HomeWizard).performAction("/el/graph/\(self.id!)/\(resolution)", completion: { (fetchResults, error) -> Void in
			
			if (error != nil) {
				XCGLogger.defaultInstance().error("EnergyLink: " + error!.localizedDescription);
				completion(results: [GraphValue]());
				return;
			}
			
			if let resultDictionary = fetchResults as? Dictionary<String, AnyObject> {
				if (resultDictionary["status"] is String && (resultDictionary["status"] as String) == "ok") {
					var items = resultDictionary["response"] as? Array<Dictionary<String, AnyObject>>;
					
					if (items == nil) {
						XCGLogger.defaultInstance().error("EnergyLink: Response does not comply to format");
						completion(results: [GraphValue]());
						return;
					}
					
					var lastEntry = self.lastGraphTimeStamp(graphResolution, dataType: kGraphDataType.Electricity);

					var formatter = NSDateFormatter();
					formatter.dateFormat = "YYYY-MM-dd HH:mm";

					for item in items! {
						if (!EnergyLink.canParseGraphValueDictionary(item)) {
							continue;
						}

						var date = formatter.dateFromString(item["t"] as String);
						
						if (date == nil) {
							continue;
						}
						
						if (lastEntry != nil) {
							var result = date!.compare(lastEntry!);
							if (result == NSComparisonResult.OrderedAscending || result == NSComparisonResult.OrderedSame) {
								continue;
							}
						}
						self.addGraphValue(item, resolution: graphResolution);
					}
				}
				completion(results: [GraphValue]());
			}
			else {
				XCGLogger.defaultInstance().error("EnergyLink: Invalid response format");
				completion(results: [GraphValue]());
				return;
			}
		});
	}
	
	class func canParseGraphValueDictionary(dict: Dictionary<String, AnyObject>) -> Bool {
		/*
		var compareDictionary: Dictionary<String, AnyObject.Type> = [
			"a" : NSNumber.self,
			"t" : NSString.self,
			"u" : NSNumber.self,
			"a" : NSNumber.self,
			"s1" : NSNumber.self,
			"s2" : NSNumber.self,
			"g" : NSNumber.self
		];
		
		for key in compareDictionary.keys {

			if (dict.indexForKey(key) == nil) || (dict[key] as? compareDictionary[key]) == nil) {
				return false;
			}
			
		}
		
		return true;
//		compareDictionary["a"] = NSNumber.self;
		
		*/
		
		if (dict.indexForKey("a") == nil || (dict["a"] as? Int) == nil) {
			return false;
		}
		
		if (dict.indexForKey("t") == nil || (dict["t"] as? String) == nil) {
			return false;
		}
		
		if (dict.indexForKey("u") == nil || (dict["u"] as? Int) == nil) {
			return false;
		}
		
		if (dict.indexForKey("a") == nil || (dict["a"] as? Int) == nil) {
			return false;
		}
		
		if (dict.indexForKey("s1") == nil || (dict["s1"] as? Int) == nil) {
			return false;
		}
		
		if (dict.indexForKey("s2") == nil || (dict["s2"] as? Int) == nil) {
			return false;
		}
		
		if (dict.indexForKey("g") == nil || (dict["g"] as? Int) == nil) {
			return false;
		}
		
		return true;
		
	}
	
	func addGraphValue(dict: Dictionary<String, AnyObject>, resolution: kGraphResolution) {

		var timeStampValue = dict["t"] as String;
		var formatter = NSDateFormatter();
		formatter.dateFormat = "YYYY-MM-dd HH:mm";
		
		var searchPredicate = NSPredicate(format: "resolution = %d AND type = %d AND timeStamp = %@",
			resolution.rawValue,
			kGraphDataType.Electricity.rawValue,
			formatter.dateFromString(timeStampValue)!);
		
		
		if (self.graphValues.filteredSetUsingPredicate(searchPredicate!).count == 0) {
			MagicalRecord.saveWithBlockAndWait({ (context) -> Void in
				var localSensor = self.inContext(context);
				
				var match = GraphValue.createEntityInContext(context);
				match.resolution = resolution.rawValue;
				match.type = kGraphDataType.Electricity.rawValue;
				match.timeStamp = formatter.dateFromString(timeStampValue);
				match.sensor = localSensor;
				match.value = dict["u"] as Int;
				
				localSensor.addGraphValuesObject(match);
			});
		}
		else {
			var t = "test";
		}
	}
	
	override func addObserversForObject(object: NSObject) {
		
		super.addObserversForObject(object);
		
		self.addObserver(object, forKeyPath: "tariff", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "t1", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "t2", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "used", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "aggregate", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "gas", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "s1", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(object, forKeyPath: "s2", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForObject(object: NSObject) {
		
		super.removeObserversForObject(object);
		
		self.removeObserver(object, forKeyPath: "tariff");
		self.removeObserver(object, forKeyPath: "t1");
		self.removeObserver(object, forKeyPath: "t2");
		self.removeObserver(object, forKeyPath: "used");
		self.removeObserver(object, forKeyPath: "aggregate");
		self.removeObserver(object, forKeyPath: "gas");
		self.removeObserver(object, forKeyPath: "s1");
		self.removeObserver(object, forKeyPath: "s2");
		
	}
	
}
