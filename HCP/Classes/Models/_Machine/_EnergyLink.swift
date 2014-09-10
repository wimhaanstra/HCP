// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EnergyLink.swift instead.

import CoreData

enum EnergyLinkAttributes: String {
    case aggregate = "aggregate"
    case gas = "gas"
    case s1 = "s1"
    case s2 = "s2"
    case t1 = "t1"
    case t2 = "t2"
    case tariff = "tariff"
    case used = "used"
}

@objc
class _EnergyLink: Sensor {

    // MARK: - Class methods

    override class func entityName () -> String {
        return "EnergyLink"
    }

    override class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _EnergyLink.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var aggregate: AnyObject?

    // func validateAggregate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var gas: AnyObject?

    // func validateGas(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var s1: AnyObject?

    // func validateS1(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var s2: AnyObject?

    // func validateS2(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var t1: String?

    // func validateT1(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var t2: String?

    // func validateT2(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var tariff: NSNumber?

    // func validateTariff(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var used: AnyObject?

    // func validateUsed(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

