//
//  CoreDataStackConfiguration.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

/**
  A `CoreDataStackConfiguration` object represents all of the information needed to create a CoreData stack.  The managed object model can be created using a `CoreDataModelSource`, which provides every possible option for creating a model.  The default model created merges all of the models in the main bundle.  Persistent stores can be added to the persistent store coordinator using an array of `CoreDataStoreParameters`.  The default list of parameters provides a single in-memory store.  Finally, the concurrency type of the managed object context can be specified in place of the default value of `PrivateQueueConcurrencyType`.
*/

public class CoreDataStackConfiguration {

    public let contextConcurrencyType: NSManagedObjectContextConcurrencyType
    public let modelSource: CoreDataModelSource
    public let storeParameters: [CoreDataStoreParameters]

    public init(concurrency: NSManagedObjectContextConcurrencyType = .PrivateQueueConcurrencyType, modelSource: CoreDataModelSource = CoreDataModelSource(), storeParameters: [CoreDataStoreParameters] = [CoreDataStoreParameters()]) {
        contextConcurrencyType = concurrency
        self.modelSource = modelSource
        self.storeParameters = storeParameters
    }

}


/**
  Enumeration to represent one of the various strategies for creating a managed object model.
*/

public enum CoreDataModelSource {

    case URLContents(NSURL)
    case MainBundleMerge(metadata: CoreDataStoreMetaData?)
    case AllBundlesMerge(metadata: CoreDataStoreMetaData?)
    case BundleMerge(bundles: [NSBundle]?, metadata: CoreDataStoreMetaData?)
    case ModelMerge(models: [NSManagedObjectModel], metadata: CoreDataStoreMetaData?)

    public init(contentURL: NSURL) {
        self = URLContents(contentURL)
    }

    public init(bundles: [NSBundle]? = nil, metadata: CoreDataStoreMetaData? = nil) {
        if bundles == nil {
            self = MainBundleMerge(metadata: metadata)
        }
        else {
            self = BundleMerge(bundles: bundles, metadata: metadata)
        }
    }

    public init(models: [NSManagedObjectModel], metadata: CoreDataStoreMetaData? = nil) {
        self = ModelMerge(models: models, metadata: metadata)
    }

}

public typealias CoreDataStoreMetaData = [NSObject:AnyObject]


/**
  Enumeration to represent one of the types of persistent stores that can be added to a persistent store coordinator in a CoreData stack.
*/

public enum CoreDataStoreParameters {

    case InMemory(configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)
    case SQLite(URL: NSURL, configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)
    case Binary(URL: NSURL, configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)

    public init() {
        self = InMemory(configuration: nil, options: nil)
    }

    /**
      Convenience method for providing the persistent store type string associated with the targeted store.
      @return `NSString` of the type of store representing in-memory, SQLite or binary.
    */
    public var storeType: String {
        switch self {
        case .InMemory(_, _):
            return NSInMemoryStoreType

        case .SQLite(_, _, _):
            return NSSQLiteStoreType

        case .Binary(_, _, _):
            return NSBinaryStoreType
        }
    }

    /**
      Convenience method for providing the URL of the persistent store associated with the targeted store.
      @return URL of the targeted store except for `nil` in the case of an in-memory store.
    */
    public var URL: NSURL? {
        switch self {
        case .InMemory(_, _):
            return nil

        case .SQLite(let URL, _, _):
            return URL

        case .Binary(let URL, _, _):
            return URL
        }
    }

    /**
      Convenience method for providing the managed object model configuration named associated with the targeted store.
      @return Model configuration name for targeted store.
    */

    public var configuration: CoreDataModelConfiguration? {
        switch self {
        case .InMemory(let configuration, _):
            return configuration

        case .SQLite(_, let configuration, _):
            return configuration

        case .Binary(_, let configuration, _):
            return configuration
        }
    }

    /**
      Convenience method for providing the persistent store options associated with the targeted store.
      @return Dictionary of options to use in the creation of a persistent store.
    */
    public var options: CoreDataStoreOptions? {
        switch self {
        case .InMemory(_, let options):
            return options

        case .SQLite(_, _, let options):
            return options

        case .Binary(_, _, let options):
            return options
        }
    }
}

public typealias CoreDataStoreOptions = [String:AnyObject]
public typealias CoreDataModelConfiguration = String
