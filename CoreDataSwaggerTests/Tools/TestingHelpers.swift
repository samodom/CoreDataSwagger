//
//  TestingHelpers.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/29/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

internal let DocumentsDirectoryURL: NSURL = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let basePath = paths[0] as! String
    return NSURL(fileURLWithPath: basePath)!
}()

internal func URLofFileInDocumentsDirectory(named filename: String) -> NSURL? {
    let path = DocumentsDirectoryURL.path!.stringByAppendingPathComponent(filename)
    return NSURL(fileURLWithPath: path)
}

internal func DeleteFile(atURL URL: NSURL) {
    let fileManager = NSFileManager.defaultManager()
    if !URL.fileURL {
        return
    }

    let filePath = URL.path!
    if fileManager.fileExistsAtPath(filePath) {
        fileManager.removeItemAtPath(filePath, error: nil)
    }
}

internal func URLofBundledFile(named filename: String, ofType type: String) -> NSURL? {
    for bundle in NSBundle.allBundles() as! [NSBundle] {
        let URL = bundle.URLForResource(filename, withExtension: type)
        if URL != nil {
            return URL
        }
    }

    return nil
}

internal func BundleForModel(named modelName: String) -> NSBundle! {
    let allBundles = NSBundle.allBundles() as! [NSBundle]
    for bundle in allBundles {
        if bundle.bundleURL.path!.rangeOfString(modelName) != nil {
            return bundle
        }
    }

    return nil
}

internal func LoadModel(named name: String) -> NSManagedObjectModel! {
    let URL = URLofBundledFile(named: name, ofType: "momd")!
    return NSManagedObjectModel(contentsOfURL: URL)!
}
