//
//  NSManagedObjectModelExtensions.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/27/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension NSManagedObjectModel {

    public class func createFromSource(source: CoreDataModelSource) -> NSManagedObjectModel? {

        switch source {
        case .URLContents(let URL):
            return NSManagedObjectModel(contentsOfURL: URL)

        case .MainBundleMerge(let metadata):
            return createFromBundleMerge(nil, metadata: metadata)

        case .AllBundlesMerge(let metadata):
            let bundles = NSBundle.allBundles() as [NSBundle]
            return createFromBundleMerge(bundles, metadata: metadata)

        case .BundleMerge(let bundles, let metadata):
            return createFromBundleMerge(bundles, metadata: metadata)

        case .ModelMerge(let models, let metadata):
            if metadata != nil {
                return NSManagedObjectModel(byMergingModels: models, forStoreMetadata: metadata!)
            }
            else {
                return NSManagedObjectModel(byMergingModels: models)
            }
        }
    }

    private class func createFromBundleMerge(bundles: [NSBundle]?, metadata: CoreDataStoreMetaData?) -> NSManagedObjectModel? {
        if metadata != nil {
            return NSManagedObjectModel.mergedModelFromBundles(bundles, forStoreMetadata: metadata!)
        }
        else {
            NSLog("Bundles: \(bundles)")
            return NSManagedObjectModel.mergedModelFromBundles(bundles)
        }

    }
}
