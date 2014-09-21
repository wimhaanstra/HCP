// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Clock.swift instead.

import CoreData

enum ClockAttributes: String {
    case timeZoneOffset = "timeZoneOffset"
}

@objc
class _Clock: Sensor {

    // MARK: - Class methods

    override class func entityName () -> String {
        return "Clock"
    }

    override class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Clock.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var timeZoneOffset: NSNumber?

    // func validateTimeZoneOffset(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

