//
//  CoreDataStack.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public class CoreDataStack {
    public let model: NSManagedObjectModel
    public let coordinator: NSPersistentStoreCoordinator
    public let rootContext: NSManagedObjectContext

    public init(datastoreURL: NSURL) {
        model = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles()) ?? NSManagedObjectModel()
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        var error: NSError?
        coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: datastoreURL, options: nil, error: &error)
        if error != nil {
            NSLog("Error adding persistent store to coordinator (URL: \(datastoreURL.absoluteString!): \(error!.debugDescription)")
        }
        rootContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        rootContext.persistentStoreCoordinator = coordinator
    }

    public init() {
        model = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles()) ?? NSManagedObjectModel()
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        var error: NSError?
        coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: &error)
        if error != nil {
            NSLog("Error adding in-memory store to coordinator: \(error!.debugDescription)")
        }
        rootContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        rootContext.persistentStoreCoordinator = coordinator
    }
}

