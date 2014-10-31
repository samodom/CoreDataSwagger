//
//  NSPersistentStoreCoordinatorExtensions.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/29/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension NSPersistentStoreCoordinator {

    public class func createWithModel(model: NSManagedObjectModel, storeParameters: [CoreDataStoreParameters]) -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)

        for parameters in storeParameters {
            let URL = parameters.URL()
            if URL != nil && !URL!.fileURL {
                NSLog("Error adding persistent store to coordinator: only file URLs are permitted")
                continue
            }

            var error: NSError?
            coordinator.addPersistentStoreWithType(parameters.storeType(), configuration: parameters.configuration(), URL: parameters.URL(), options: parameters.options(), error: &error)

            if error != nil {
                NSLog("Error adding persistent store to coordinator: \(error!.debugDescription)")
            }
        }

        return coordinator
    }

}
