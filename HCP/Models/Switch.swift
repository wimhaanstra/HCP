@objc(Switch)
class Switch: _Switch {

    func on() -> Void {
        
        (self.controller! as HomeWizard).performAction(String(format: "/sw/%d/on", self.id!), completion: { (results) -> Void in
        });
        
    }
    
    func off() -> Void {

        (self.controller! as HomeWizard).performAction(String(format: "/sw/%d/off", self.id!), completion: { (results) -> Void in
        });
    
    }
	
	func stateValue() -> String {
		if (self.status!.boolValue) {
			return "on";
		}
		else {
			return "off";
		}
	}

}
