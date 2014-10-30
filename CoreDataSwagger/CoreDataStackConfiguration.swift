//
//  CoreDataStackConfiguration.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public class CoreDataStackConfiguration {

    public let contextConcurrencyType: NSManagedObjectContextConcurrencyType
    public let modelSource: CoreDataModelSource
    public let storeParameters: [CoreDataStoreParameters]

    public init(concurrency: NSManagedObjectContextConcurrencyType = .MainQueueConcurrencyType, modelSource: CoreDataModelSource = CoreDataModelSource(), storeParameters: [CoreDataStoreParameters] = [CoreDataStoreParameters()]) {
        contextConcurrencyType = concurrency
        self.modelSource = modelSource
        self.storeParameters = storeParameters
    }

}

public typealias CoreDataStoreMetaData = [NSObject:AnyObject]

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

public typealias CoreDataStoreOptions = [NSString:AnyObject]
public typealias CoreDataModelConfiguration = NSString

public enum CoreDataStoreParameters {

    case InMemory(configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)
    case SQLite(URL: NSURL, configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)
    case Binary(URL: NSURL, configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)

    public init() {
        self = InMemory(configuration: nil, options: nil)
    }

    public func storeType() -> NSString {
        switch self {
        case .InMemory(_, _):
            return NSInMemoryStoreType

        case .SQLite(_, _, _):
            return NSSQLiteStoreType

        case .Binary(_, _, _):
            return NSBinaryStoreType
        }
    }

    public func URL() -> NSURL? {
        switch self {
        case .InMemory(_, _):
            return nil

        case .SQLite(let URL, _, _):
            return URL

        case .Binary(let URL, _, _):
            return URL
        }
    }

    public func configuration() -> CoreDataModelConfiguration? {
        switch self {
        case .InMemory(let configuration, _):
            return configuration

        case .SQLite(_, let configuration, _):
            return configuration

        case .Binary(_, let configuration, _):
            return configuration
        }
    }

    public func options() -> CoreDataStoreOptions? {
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
