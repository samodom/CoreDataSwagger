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
    let sampleMetadata = [ "one": "two", "three": "four" ] as [NSObject:AnyObject]
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

    func testBundleMergeWithAllBundlesNoMetadata() {
        modelSource = CoreDataModelSource()
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .BundleMerge(let bundles, let metadata):
            XCTAssert(true, "The source type should be a bundle merge")
            XCTAssertTrue(bundles == nil, "The source should use a nil bundles value to specify all bundles")
            XCTAssertTrue(metadata == nil, "The source's metadata should be nil")

        default:
            XCTFail("The source type created should be a bundle merge")
        }
    }

    func testBundleMergeWithAllBundlesWithMetadata() {
        modelSource = CoreDataModelSource(metadata: sampleMetadata)
        switch modelSource! { //  FIXME: why does this need to be unwrapped?!?!
        case .BundleMerge(let bundles, let metadata):
            XCTAssert(true, "The source type should be a bundle merge")
            XCTAssertTrue(bundles == nil, "The source should use a nil bundles value to specify all bundles")
            XCTAssertEqual(metadata!.count, 2, "The provided dictionary had two members")
            XCTAssertEqual(metadata!["one"] as String, "two", "The source should use the metadata provided")
            XCTAssertEqual(metadata!["three"] as String, "four", "The source should use the metadata provided")

        default:
            XCTFail("The source type created should be a bundle merge")
        }
    }

    func testBundleMergeWithSomeBundlesNoMetadata() {
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

    func testBundleMergeWithSomeBundlesAndMetadata() {
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

    //    case ModelMerge(models: [NSManagedObjectModel], metadata: [NSObject:AnyObject]?)

    func testModelMergeWithSomeModelsNoMetadata() {
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

    func testModelMergeWithSomeModelsAndMetadata() {
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
