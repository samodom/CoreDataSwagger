//
//  CoreDataStack.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public typealias CoreDataPerformClosure = () -> Void

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

public typealias CoreDataFetchResults = ([NSManagedObject]?, NSError?)

extension CoreDataStack {

    public func fetch(request: NSFetchRequest) -> CoreDataFetchResults {
        var error: NSError?
        let results = context.executeFetchRequest(request, error: &error) as [NSManagedObject]?
        return (results, error)
    }

}