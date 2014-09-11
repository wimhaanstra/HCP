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

}
