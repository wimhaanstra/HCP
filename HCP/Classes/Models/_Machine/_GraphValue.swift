// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to GraphValue.swift instead.

import CoreData

enum GraphValueAttributes: String {
    case resolution = "resolution"
    case timeStamp = "timeStamp"
    case type = "type"
    case value = "value"
}

enum GraphValueRelationships: String {
    case sensor = "sensor"
}

@objc
class _GraphValue: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "GraphValue"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _GraphValue.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var resolution: NSNumber?

    // func validateResolution(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var timeStamp: NSDate?

    // func validateTimeStamp(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var type: NSNumber?

    // func validateType(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var value: NSNumber?

    // func validateValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var sensor: Sensor?

    // func validateSensor(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

