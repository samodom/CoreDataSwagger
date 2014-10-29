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

        case .BundleMerge(let bundles, let metadata):
            if metadata != nil {
                return NSManagedObjectModel.mergedModelFromBundles(bundles, forStoreMetadata: metadata!)
            }
            else {
                return NSManagedObjectModel.mergedModelFromBundles(bundles)
            }

        case .ModelMerge(let models, let metadata):
            if metadata != nil {
                return NSManagedObjectModel(byMergingModels: models, forStoreMetadata: metadata!)
            }
            else {
                return NSManagedObjectModel(byMergingModels: models)
            }

        default:
            return nil
        }
    }

}
