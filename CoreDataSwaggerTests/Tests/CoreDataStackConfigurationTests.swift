//
//  CoreDataStackConfigurationTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class CoreDataStackConfigurationTests: XCTestCase {

    var configuration: CoreDataStackConfiguration!
    let modelURL = NSURL(string: "/var/stuff/foobar/data.mom")!
    var sampleModelSource: CoreDataModelSource!
    let memoryStore = CoreDataStoreParameters()
    let storeURL = NSURL(string: "/var/stuff/foobar/datastore.sqlite")!
    var fileStore: CoreDataStoreParameters!
    let storeOptions = ["one": "two", "three": "four"]

    override func setUp() {
        super.setUp()

        configuration = CoreDataStackConfiguration()
        sampleModelSource = CoreDataModelSource(contentURL: modelURL)
        fileStore = CoreDataStoreParameters.SQLite(URL: storeURL, configuration: "Sample Configuration", options: storeOptions)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDefaultConfiguration() {
        XCTAssertEqual(configuration.contextConcurrencyType, NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType, "The default context concurrency should use the main queue")

        switch configuration.modelSource {
        case .MainBundleMerge(let metadata):
            XCTAssert(true, "The default configuration should use a main bundle merge as a model source")
            XCTAssertTrue(metadata == nil, "The default configuration should use a model source without metadata")

        default:
            XCTFail("The default configuration should use a main bundle merge as a model source")
        }

        XCTAssertEqual(configuration.storeParameters.count, 1, "There should only be one set of store parameters in a default configuration")
        switch configuration.storeParameters[0] {
        case .InMemory(let configuration, let options):
            XCTAssert(true, "The default configuration should use an in-memory datastore")
            XCTAssertTrue(configuration == nil, "The default configuration should use the default configuration")
            XCTAssertTrue(options == nil, "The default ")

        default:
            XCTFail("The default configuration should use an in-memory datastore")
        }
    }

    func testCustomConfiguration() {
        configuration = CoreDataStackConfiguration(concurrency: .PrivateQueueConcurrencyType, modelSource: sampleModelSource, storeParameters: [memoryStore, fileStore])
        XCTAssertEqual(configuration.contextConcurrencyType, NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType, "A custom configuration should use the context concurrency type provided")

        switch configuration.modelSource {
        case .URLContents(let URL):
            XCTAssertEqual(URL, modelURL, "The configuration should use the model source provided")

        default:
            XCTFail("The configuration should use the model source provided")
        }

        var store = configuration.storeParameters[0]
        switch store {
        case .InMemory:
            XCTAssert(true, "The configuration should use the store parameters that were provided")

        default:
            XCTFail("The configuration should use the store parameters that were provided")
        }

        store = configuration.storeParameters[1]
        switch store {
        case .SQLite:
            XCTAssert(true, "The configuration should use the store parameters that were provided")

        default:
            XCTFail("The configuration should use the store parameters that were provided")
        }

    }
}
