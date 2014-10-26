//
//  CoreDataStoreParameterTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class CoreDataStoreParameterTests: XCTestCase {

    var storeParameters: CoreDataStoreParameters!
    let localURL = NSURL(string: "/var/stuff/foobar/datastore.sqlite")!
    let remoteURL = NSURL(string: "http://www.example.com/datatstore.sqlite")!
    let sampleConfiguration = "Sample Configuration" as CoreDataModelConfiguration
    let sampleOptions = ["alpha": "bravo", "charlie": "delta"] as CoreDataStoreOptions

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testDefaultStoreParameters() {
        storeParameters = CoreDataStoreParameters()
        switch storeParameters! {
        case .InMemory(let configuration, let options):
            XCTAssert(true, "The default store parameters should use an in-memory store")
            XCTAssertTrue(configuration == nil, "The default store parameters should not have a configuration")
            XCTAssertTrue(options == nil, "The default store parameters should not have any options")

        default:
            XCTFail("The default store parameters should be an in-memory store")
        }
    }

    func testInMemoryStoreParametersNoConfigurationNoOptions() {
        storeParameters = .InMemory(configuration: nil, options: nil)
        switch storeParameters! {
        case .InMemory(let configuration, let options):
            XCTAssertTrue(configuration == nil, "The store parameters should not have a configuration")
            XCTAssertTrue(options == nil, "The store parameters should not have any options")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testInMemoryStoreParametersWithConfigurationAndOptions() {
        storeParameters = .InMemory(configuration: sampleConfiguration, options: sampleOptions)
        switch storeParameters! {
        case .InMemory(let configuration, let options):
            XCTAssertEqual(configuration!, sampleConfiguration, "The store parameters should use the provided configuration")
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The store parameters should use the provided options")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The store parameters should use the provided options")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testSQLiteStoreParametersNoConfigurationNoOptions() {
        storeParameters = .SQLite(URL: localURL, configuration: nil, options: nil)
        switch storeParameters! {
        case .SQLite(let URL, let configuration, let options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertTrue(configuration == nil, "The store parameters should not have a configuration")
            XCTAssertTrue(options == nil, "The store parameters should not have any options")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testSQLiteStoreParametersWithConfigurationAndOptions() {
        storeParameters = .SQLite(URL: localURL, configuration: sampleConfiguration, options: sampleOptions)
        switch storeParameters! {
        case .SQLite(let URL, let configuration, let options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertEqual(configuration!, sampleConfiguration, "The store parameters should use the provided configuration")
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The store parameters should use the provided options")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The store parameters should use the provided options")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testBinaryStoreParametersNoConfigurationNoOptions() {
        storeParameters = .Binary(URL: localURL, configuration: nil, options: nil)
        switch storeParameters! {
        case .Binary(let URL, let configuration, let options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertTrue(configuration == nil, "The store parameters should not have a configuration")
            XCTAssertTrue(options == nil, "The store parameters should not have any options")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testBinaryStoreParametersWithConfigurationAndOptions() {
        storeParameters = .Binary(URL: localURL, configuration: sampleConfiguration, options: sampleOptions)
        switch storeParameters! {
        case .Binary(let URL, let configuration, let options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertEqual(configuration!, sampleConfiguration, "The store parameters should use the provided configuration")
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The store parameters should use the provided options")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The store parameters should use the provided options")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

}
