//
//  CoreDataModelSourceTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class CoreDataModelSourceTests: XCTestCase {

    var modelSource: CoreDataModelSource!
    let sampleMetadata = [ "one": "two", "three": "four" ] as CoreDataStoreMetaData
    let sampleBundles = [ NSBundle(), NSBundle() ]
    let sampleModels = [ NSManagedObjectModel(), NSManagedObjectModel() ]

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testURLContentsModelSource() {
        let URL = NSURL(string: "http://www.example.com/model.mom")!
        modelSource = CoreDataModelSource(contentURL: URL)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .URLContents(let associatedURL):
            XCTAssert(true, "The source type should be URL content")
            XCTAssertEqual(associatedURL, URL, "The source should use the provided URL")

        default:
            XCTFail("The source type created should be a URL content source")
        }
    }

    func testMainBundleMergeNoMetadata() {
        modelSource = CoreDataModelSource()
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .MainBundleMerge(let metadata):
            XCTAssert(true, "The source type should be a main bundle merge")
            XCTAssertTrue(metadata == nil, "The source's metadata should be nil")

        default:
            XCTFail("The source type created should be a main bundle merge")
        }
    }

    func testMainBundleMergeWithMetadata() {
        modelSource = CoreDataModelSource(metadata: sampleMetadata)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .MainBundleMerge(let metadata):
            XCTAssert(true, "The source type should be a main bundle merge")
            let cast = metadata as [NSObject:AnyObject]!  //  FIXME: why do I have to cast this?
            XCTAssertEqual(cast.count, 2, "The provided dictionary had two members")
            XCTAssertEqual(cast["one"] as String, "two", "The source should use the metadata provided")
            XCTAssertEqual(cast["three"] as String, "four", "The source should use the metadata provided")

        default:
            XCTFail("The source type created should be a main bundle merge")
        }
    }

    func testAllBundlesMergeNoMetadata() {
        modelSource = CoreDataModelSource.AllBundlesMerge(metadata: nil)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .AllBundlesMerge(let metadata):
            XCTAssert(true, "The source type should be an all bundles merge")
            XCTAssertTrue(metadata == nil, "The source's metadata should be nil")

        default:
            XCTFail("The source type created should be an all bundles merge")
        }
    }

    func testAllBundlesMergeWithMetadata() {
        modelSource = CoreDataModelSource.AllBundlesMerge(metadata: sampleMetadata)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .AllBundlesMerge(let metadata):
            let data = metadata as CoreDataStoreMetaData!  //  FIXME: why do I have to do this?
            XCTAssert(true, "The source type should be an all bundles merge")
            XCTAssertEqual(data.count, 2, "The provided dictionary had two members")
            XCTAssertEqual(data["one"] as String, "two", "The source should use the metadata provided")
            XCTAssertEqual(data["three"] as String, "four", "The source should use the metadata provided")

        default:
            XCTFail("The source type created should be an all bundles merge")
        }
    }

    func testBundleMergeNoMetadata() {
        modelSource = CoreDataModelSource(bundles: sampleBundles)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .BundleMerge(let bundles, let metadata):
            XCTAssert(true, "The source type should be a bundle merge")
            XCTAssertEqual(bundles!, sampleBundles, "The source should use the bundles provided")
            XCTAssertTrue(metadata == nil, "The source's metadata should be nil")

        default:
            XCTFail("The source type created should be a bundle merge")
        }
    }

    func testBundleMergeWithMetadata() {
        modelSource = CoreDataModelSource(bundles: sampleBundles, metadata: sampleMetadata)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .BundleMerge(let bundles, let metadata):
            XCTAssert(true, "The source type should be a bundle merge")
            XCTAssertEqual(bundles!, sampleBundles, "The source should use the bundles provided")
            XCTAssertEqual(metadata!.count, 2, "The provided dictionary had two members")
            XCTAssertEqual(metadata!["one"] as String, "two", "The source should use the metadata provided")
            XCTAssertEqual(metadata!["three"] as String, "four", "The source should use the metadata provided")

        default:
            XCTFail("The source type created should be a bundle merge")
        }
    }

    func testModelMergeNoMetadata() {
        modelSource = CoreDataModelSource(models: sampleModels)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .ModelMerge(let models, let metadata):
            XCTAssert(true, "The source type should be a model merge")
            XCTAssertEqual(models, sampleModels, "The source should use the models provided")
            XCTAssertTrue(metadata == nil, "The source's metadata should be nil")

        default:
            XCTFail("The source type created should be a bundle merge")
        }
    }

    func testModelMergeWithMetadata() {
        modelSource = CoreDataModelSource(models: sampleModels, metadata: sampleMetadata)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .ModelMerge(let models, let metadata):
            XCTAssert(true, "The source type should be a model merge")
            XCTAssertEqual(models, sampleModels, "The source should use the models provided")
            XCTAssertEqual(metadata!.count, 2, "The provided dictionary had two members")
            XCTAssertEqual(metadata!["one"] as String, "two", "The source should use the metadata provided")
            XCTAssertEqual(metadata!["three"] as String, "four", "The source should use the metadata provided")

        default:
            XCTFail("The source type created should be a bundle merge")
        }
    }

}
