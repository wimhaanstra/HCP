@objc(Dimmer)
class Dimmer: _Dimmer {
	
	func dim(dimValue: Int) -> Void {
		(self.controller! as HomeWizard).performAction(String(format: "/sw/dim/%d/%@", self.id!, self.stateValue()), completion: { (results) -> Void in
			self.dimValue = dimValue;
		});
	}
	
	override func update(definition: NSDictionary) {
		super.update(definition);
		
		if let dimmerValue = definition.objectForKey("dimlevel") as? Int {
			self.dimValue = definition.objectForKey("dimlevel") as? Int;
		}
	}
	
}
