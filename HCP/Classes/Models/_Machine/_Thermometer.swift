// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Thermometer.swift instead.

import CoreData

enum ThermometerAttributes: String {
    case channel = "channel"
    case humidity = "humidity"
    case outside = "outside"
    case temperature = "temperature"
}

@objc
class _Thermometer: Sensor {

    // MARK: - Class methods

    override class func entityName () -> String {
        return "Thermometer"
    }

    override class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Thermometer.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var channel: NSNumber?

    // func validateChannel(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var humidity: AnyObject?

    // func validateHumidity(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var outside: NSNumber?

    // func validateOutside(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var temperature: AnyObject?

    // func validateTemperature(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

