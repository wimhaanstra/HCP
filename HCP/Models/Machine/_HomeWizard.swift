// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HomeWizard.swift instead.

import CoreData

enum HomeWizardAttributes: String {
    case password = "password"
}

@objc
class _HomeWizard: Controller {

    // MARK: - Class methods

    override class func entityName () -> String {
        return "HomeWizard"
    }

    override class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _HomeWizard.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var password: String?

    // func validatePassword(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

