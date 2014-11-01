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
      Simpler interface for performing a fetch request on a managed object context and returning managed objects.
      @param        request Fetch request to execute on the managed object context.
      @return       A mutually exclusive ordered pair with the results of performing the fetch or any error encountered.
      @discussion   The fetch request must have the `resultsType` set to `ManagedObjectResultType` (which it is by default).
    */
    public func fetch(request: NSFetchRequest) -> CoreDataObjectFetchResults {
        assert(request.resultType == .ManagedObjectResultType, "The fetch request must be configured to return managed objects")
        var error: NSError?
        let results = context.executeFetchRequest(request, error: &error) as [NSManagedObject]?
        return (results, error)
    }

    /**
    Simpler interface for performing a fetch request on a managed object context and returning managed object identifiers.
      @param        request Fetch request to execute on the managed object context.
      @return       A mutually exclusive ordered pair with the results of performing the fetch or any error encountered.
      @discussion   The fetch request must have the `resultsType` set to `ManagedObjectIDResultType`.
    */
    public func fetchIDs(request: NSFetchRequest) -> CoreDataObjectIDFetchResults {
        assert(request.resultType == .ManagedObjectIDResultType, "The fetch request must be configured to return managed object identifiers")
        var error: NSError?
        let results = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]?
        return (results, error)
    }

    /**
    Simpler interface for performing a fetch request on a managed object context and returning dictionaries with object values.
      @param        request Fetch request to execute on the managed object context.
      @return       A mutually exclusive ordered pair with the results of performing the fetch or any error encountered.
      @discussion   The fetch request must have the `resultsType` set to `DictionaryResultType`.
    */
    public func fetchDictionaries(request: NSFetchRequest) -> CoreDataDictionaryFetchResults {
        assert(request.resultType == .DictionaryResultType, "The fetch request must be configured to return object dictionaries")
        var error: NSError?
        let results = context.executeFetchRequest(request, error: &error)
        return (results, error)
    }

    /**
    Simpler interface for performing a count fetch request on a managed object context and returning an object count.
      @param        request Fetch request to execute on the managed object context.
      @return       A mutually exclusive ordered pair with the count of the results that would be returned when performing the fetch or any error encountered.
      @discussion   The fetch request must have the `resultsType` set to `CountResultType`.
    */
    public func count(request: NSFetchRequest) -> CoreDataCountFetchResults {
        assert(request.resultType == .CountResultType, "The fetch request must be configured to return an object count")
        var error: NSError?
        var resultCount = context.countForFetchRequest(request, error: &error)
        if error != nil {
            return (nil, error)
        }

        return (UInt(resultCount), nil)
    }

}

public typealias CoreDataObjectFetchResults = ([NSManagedObject]?, NSError?)
public typealias CoreDataObjectIDFetchResults = ([NSManagedObjectID]?, NSError?)
public typealias CoreDataDictionaryFetchResults = ([AnyObject]?, NSError?)
public typealias CoreDataCountFetchResults = (UInt?, NSError?)
