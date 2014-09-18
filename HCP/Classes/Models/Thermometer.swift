@objc(Thermometer)
class Thermometer: _Thermometer {

	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let channelValue = definition.objectForKey("channel") as? Int {
			self.channel = channelValue;
		}

		var humidityValue = (self.humidity == nil) ? CombinedValue() : self.humidity as CombinedValue;
		self.parseCombinedByName("hu", value: humidityValue, definition: definition);
		self.humidity = humidityValue;
		
		var temperatureValue = (self.temperature == nil) ? CombinedValue() : self.temperature as CombinedValue;
		self.parseCombinedByName("te", value: temperatureValue, definition: definition);
		self.temperature = temperatureValue;
		
	}
	
	func parseCombinedByName(name: String, value: CombinedValue, definition: NSDictionary) {
		
		if let nameValue = definition.objectForKey(name) as? NSNumber {
			value.currentValue = nameValue;
		}
		
		if let namePlusTime = definition.objectForKey(name + "+t") as? String {
			value.maxTime = namePlusTime;
		}
		
		if let namePlusValue = definition.objectForKey(name + "+") as? NSNumber {
			value.maxValue = namePlusValue;
		}
		
		if let nameMinusValue = definition.objectForKey(name + "-") as? NSNumber {
			value.minValue = nameMinusValue;
		}

		if let nameMinusTime = definition.objectForKey(name + "-t") as? String {
			value.minTime = nameMinusTime;
		}
		
	}
	
	override func addObserversForView(view: UIView) {
		
		super.addObserversForView(view);
		
		self.addObserver(view, forKeyPath: "channel", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "humidity", options: NSKeyValueObservingOptions.New, context: nil);
		self.addObserver(view, forKeyPath: "temperature", options: NSKeyValueObservingOptions.New, context: nil);
		
	}
	
	override func removeObserversForView(view: UIView) {
		
		super.removeObserversForView(view);
		
		self.removeObserver(view, forKeyPath: "channel");
		self.removeObserver(view, forKeyPath: "humidity");
		self.removeObserver(view, forKeyPath: "temperature");
		
	}
}
