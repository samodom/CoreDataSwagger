//
//  CoreDataStack.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public typealias CoreDataPerformClosure = () -> Void

/**
  Convenience class to unify the various components used in a CoreData implementation.  Default stack creation uses a managed object model merged from all models in the main bundle, a single in-memory persistent store and private queue concurrency with the managed object context.
*/

public class CoreDataStack {

    public let model: NSManagedObjectModel!
    public let coordinator: NSPersistentStoreCoordinator!
    public let context: NSManagedObjectContext!

    public init?(configuration: CoreDataStackConfiguration = CoreDataStackConfiguration()) {
        if let modelFromSource = NSManagedObjectModel.createFromSource(configuration.modelSource) {
            model = modelFromSource
        }
        else {
            NSLog("Error creating managed object model")
            return nil
        }

        coordinator = NSPersistentStoreCoordinator.createWithModel(model, storeParameters: configuration.storeParameters)

        context = NSManagedObjectContext(concurrencyType: configuration.contextConcurrencyType)
        context.persistentStoreCoordinator = coordinator
    }

}

extension CoreDataStack {

    /**
      Convenience method for saving changes to the managed object context with the option of wrapping the manipulation of managed objects in a synchronous block beforehand.
      @param    closure Closure containing any code to be executed synchronously before saving.
      @return   An ordered pair indicating whether or not the save was successful and, on failure, an error object.
    */

    public func save(closure: CoreDataPerformClosure? = nil) -> (Bool, NSError?) {
        var success = false
        var error: NSError?
        context.performBlockAndWait {
            closure?()
            success = self.context.save(&error)
        }

        return (success, error)
    }

}

extension CoreDataStack {

    /**
      Simpler interface to performing a fetch request on a managed object context.
      @param    request Fetch request to execute on the managed object context.
      @return   An mutually exclusive ordered pair with the results of performing the fetch or any error encountered.
    */
    public func fetch(request: NSFetchRequest) -> CoreDataFetchResults {
        var error: NSError?
        let results = context.executeFetchRequest(request, error: &error) as [NSManagedObject]?
        return (results, error)
    }

}

public typealias CoreDataFetchResults = ([NSManagedObject]?, NSError?)
