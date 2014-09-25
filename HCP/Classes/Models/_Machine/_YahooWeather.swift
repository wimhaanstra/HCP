// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YahooWeather.swift instead.

import CoreData

enum YahooWeatherAttributes: String {
    case refreshRate = "refreshRate"
}

@objc
class _YahooWeather: Controller {

    // MARK: - Class methods

    override class func entityName () -> String {
        return "YahooWeather"
    }

    override class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _YahooWeather.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var refreshRate: NSNumber?

    // func validateRefreshRate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

