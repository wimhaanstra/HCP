enum kGraphResolution: Int {
	case Day = 1, Week = 2, Month = 3, Year = 4
	
	static let allValues = [Day, Week, Month, Year];
	
	func stringValue() -> String {
		switch (self) {
		case .Day:
			return "day";
		case .Week:
			return "week";
		case .Month:
			return "month";
		case .Year:
			return "year";
		}
	}
}

enum kGraphDataType: Int {
	case Electricity = 1, Solar = 2, Water = 3
	
	static let allValues = [ Electricity, Solar, Water ];
	
	func stringValue() -> String {
		switch (self) {
		case .Electricity:
			return "Electricity";
		case .Solar:
			return "Solar";
		case .Water:
			return "Water";
		}
	}
}