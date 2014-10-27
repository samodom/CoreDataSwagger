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

public typealias CoreDataStoreOptions = [String:AnyObject]
public typealias CoreDataModelConfiguration = String

public enum CoreDataStoreParameters {
    case InMemory(configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)
    case SQLite(URL: NSURL, configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)
    case Binary(URL: NSURL, configuration: CoreDataModelConfiguration?, options: CoreDataStoreOptions?)

    public init() {
        self = InMemory(configuration: nil, options: nil)
    }
}
