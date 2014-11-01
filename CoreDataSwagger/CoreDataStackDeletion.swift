//
//  CoreDataStackDeletion.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension CoreDataStack {

    /**
    Simple interface for deleting a managed object from a persistent store.
      @param        object Managed object to delete.
      @discussion   This method does not save the changes to the managed object context.
    */
    public func delete(object: NSManagedObject) {
        context.deleteObject(object)
    }

    /**
    Simple interface for deleting multiple managed objects from a persistent store.
      @param        objects Managed objects to delete.
      @discussion   This method does not save the changes to the managed object context.
    */
    public func delete(objects: [NSManagedObject]) {
        for object in objects {
            delete(object)
        }
    }

    /**
    Simple interface for deleting a managed object from a persistent store by using its identifier.
      @param        objectID Identifier of managed object to delete.
      @discussion   This method does not save the changes to the managed object context.
    */
    public func delete(identifier: NSManagedObjectID) {
        let object = context.objectRegisteredForID(identifier)
        if object != nil {
            delete(object!)
        }
    }

    /**
    Simple interface for deleting multiple managed objects from a persistent store by using their identifiers.
      @param        objectIDs Identifiers of managed objects to delete.
      @discussion   This method does not save the changes to the managed object context.
    */
    public func delete(identifiers: [NSManagedObjectID]) {
        for identifier in identifiers {
            delete(identifier)
        }
    }

    /**
    Simple interface for deleting managed objects returned as the result of performing a fetch request.
      @param        fetchRequest Fetch request to perform for obtaining objects to delete.
      @discussion   The fetch request must be configured to return objects or object IDs as its results type.  Additionally, this method does not save the changes to the managed object context.
    */
    public func delete(fetchRequest: NSFetchRequest) {
        validateDeletionFetchRequestResultType(fetchRequest.resultType)

        if fetchRequest.resultType == NSFetchRequestResultType.ManagedObjectResultType {
            deleteWithObjectsFetchRequest(fetchRequest)
        }

        else {
            deleteWithObjectIDsFetchRequest(fetchRequest)
        }
    }

    private func deleteWithObjectsFetchRequest(fetchRequest: NSFetchRequest) {
        var results: [NSManagedObject]?
        var error: NSError?
        (results, error) = fetch(fetchRequest)
        if error != nil {
            handleDeletionFetchError(error!)
        }
        else {
            delete(results!)
        }
    }

    private func deleteWithObjectIDsFetchRequest(fetchRequest: NSFetchRequest) {
        var results: [NSManagedObjectID]?
        var error: NSError?
        (results, error) = fetchIDs(fetchRequest)
        if error != nil {
            handleDeletionFetchError(error!)
        }
        else {
            delete(results!)
        }
    }

    private func validateDeletionFetchRequestResultType(fetchRequestResultType: NSFetchRequestResultType) {
        if fetchRequestResultType == NSFetchRequestResultType.ManagedObjectResultType {
            return
        }
        else if fetchRequestResultType == NSFetchRequestResultType.ManagedObjectIDResultType {
            return
        }

        assert(false, "Deletion fetch requests must be configured to return managed objects or their identifiers")
    }

    private func handleDeletionFetchError(error: NSError) {
        NSLog("Error fetching objects to delete: \(error.debugDescription)")
    }

}
