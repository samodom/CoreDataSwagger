//
//  NSManagedObjectExtensions.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension NSManagedObject {

    public class func fetchRequestWithStack(stack: CoreDataStack) -> NSFetchRequest? {
        let entity = entityForThisClass(inModel: stack.model)
        if entity == nil {
            return nil
        }

        return NSFetchRequest(entityName: entity!.name!)
    }

    private class func entityForThisClass(inModel model: NSManagedObjectModel) -> NSEntityDescription? {
        for entity in model.entities as [NSEntityDescription] {
            if entity.managedObjectClassName == NSStringFromClass(self) {
                return entity
            }
        }

        return nil
    }

}

public protocol CoreDataFetchable {
    typealias FetchableClass: CoreDataFetchable
    class func fetchWithStack(stack: CoreDataStack) -> ([CoreDataFetchable]?, NSError?)
}

extension NSManagedObject: CoreDataFetchable {

    typealias FetchableClass = Self

    public class func fetchWithStack(stack: CoreDataStack) -> ([FetchableClass]?, NSError?) {
        let fetchRequest = fetchRequestWithStack(stack)
        if fetchRequest == nil {
            return (nil, NSError(domain: CoreDataSwaggerErrorDomain, code: NSCoreDataError, userInfo: nil))
        }

        var error: NSError?
        let results = stack.context.executeFetchRequest(fetchRequest!, error: &error)
        let castResults = results as [CoreDataFetchable]
        return (castResults, error)
    }

}
