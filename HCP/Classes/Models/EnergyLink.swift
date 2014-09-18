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
	
	override func addObserversForView(view: UIView) {
		
		super.addObserversForView(view);
		
		self.addObserver(view, forKeyPath: "tariff", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "t1", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "t2", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "used", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "aggregate", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "gas", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "s1", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "s2", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForView(view: UIView) {
		
		super.removeObserversForView(view);

		self.removeObserver(view, forKeyPath: "tariff");
		self.removeObserver(view, forKeyPath: "t1");
		self.removeObserver(view, forKeyPath: "t2");
		self.removeObserver(view, forKeyPath: "used");
		self.removeObserver(view, forKeyPath: "aggregate");
		self.removeObserver(view, forKeyPath: "gas");
		self.removeObserver(view, forKeyPath: "s1");
		self.removeObserver(view, forKeyPath: "s2");
		
	}

}
