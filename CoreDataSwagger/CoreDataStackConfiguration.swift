//
//  CoreDataStackConfiguration.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public enum CoreDataModelSource {
    case URLContents(NSURL)
    case BundleMerge(bundles: [NSBundle]?, metadata: [NSObject:AnyObject]?)
    case ModelMerge(models: [NSManagedObjectModel], metadata: [NSObject:AnyObject]?)

    public init(contentURL: NSURL) {
        self = URLContents(contentURL)
    }

    public init(bundles: [NSBundle]? = nil, metadata: [NSObject:AnyObject]? = nil) {
        self = BundleMerge(bundles: bundles, metadata: metadata)
    }

    public init(models: [NSManagedObjectModel], metadata: [NSObject:AnyObject]? = nil) {
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
