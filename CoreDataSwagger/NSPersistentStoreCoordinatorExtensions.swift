//
//  NSPersistentStoreCoordinatorExtensions.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/29/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension NSPersistentStoreCoordinator {

    /**
      Convenience method to create a persistent store coordinator from a managed object model and a list of `CoreDataStoreParameters`.
      @param    model NSManagedObjectModel to use with the persistent store coordinator.
      @param    storeParameters An array of store parameters to use in adding persistent stores to the coordinator after creation.
      @return   Persistent store coordinator with the provided model that has one persistent store for each set of parameters provided.
    */

    public class func createWithModel(model: NSManagedObjectModel, storeParameters: [CoreDataStoreParameters]) -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        for parameters in storeParameters {
            let URL = parameters.URL
            if URL != nil && !URL!.fileURL {
                NSLog("Error adding persistent store to coordinator: only file URLs are permitted")
                continue
            }

            var error: NSError?
            coordinator.addPersistentStoreWithType(parameters.storeType, configuration: parameters.configuration, URL: URL, options: parameters.options, error: &error)

            if error != nil {
                NSLog("Error adding persistent store to coordinator: \(error!.debugDescription)")
            }
        }

        return coordinator
    }

}
