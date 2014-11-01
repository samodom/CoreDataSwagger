//
//  StoreParameterTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class StoreParameterTests: XCTestCase {

    var storeParameters: CoreDataStoreParameters!
    let localURL = NSURL(string: "/var/stuff/foobar/datastore.dat")!
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
            XCTAssertTrue(storeParameters.URL() == nil, "In-memory stores do not have URLs")
            XCTAssertTrue(configuration == nil, "The store parameters should not have a configuration")
            XCTAssertTrue(storeParameters.configuration() == nil, "The configuration should be available through the interface")
            XCTAssertTrue(options == nil, "The store parameters should not have any options")
            XCTAssertTrue(storeParameters.options() == nil, "The options should be available through the interface")
            XCTAssertEqual(storeParameters.storeType(), NSInMemoryStoreType, "The store type should be in-memory")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testInMemoryStoreParametersWithConfigurationAndOptions() {
        storeParameters = .InMemory(configuration: sampleConfiguration, options: sampleOptions)
        switch storeParameters! {
        case .InMemory(let configuration, var options):
            XCTAssertEqual(configuration!, sampleConfiguration, "The store parameters should use the provided configuration")
            XCTAssertEqual(storeParameters.configuration()!, sampleConfiguration, "The configuration should be available through the interface")
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The store parameters should use the provided options")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The store parameters should use the provided options")
            options = storeParameters.options()!
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The options should be available through the interface")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The options should be available through the interface")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testSQLiteStoreParametersNoConfigurationNoOptions() {
        storeParameters = .SQLite(URL: localURL, configuration: nil, options: nil)
        switch storeParameters! {
        case .SQLite(let URL, let configuration, let options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertEqual(storeParameters.URL()!, localURL, "The URL should be available through the interface")
            XCTAssertTrue(configuration == nil, "The store parameters should not have a configuration")
            XCTAssertTrue(storeParameters.configuration() == nil, "The configuration should be available through the interface")
            XCTAssertTrue(options == nil, "The store parameters should not have any options")
            XCTAssertTrue(storeParameters.options() == nil, "The options should be available through the interface")
            XCTAssertEqual(storeParameters.storeType(), NSSQLiteStoreType, "The store type should be SQLite")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testSQLiteStoreParametersWithConfigurationAndOptions() {
        storeParameters = .SQLite(URL: localURL, configuration: sampleConfiguration, options: sampleOptions)
        switch storeParameters! {
        case .SQLite(let URL, let configuration, var options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertEqual(configuration!, sampleConfiguration, "The store parameters should use the provided configuration")
            XCTAssertEqual(storeParameters.configuration()!, sampleConfiguration, "The configuration should be available through the interface")
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The store parameters should use the provided options")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The store parameters should use the provided options")
            options = storeParameters.options()!
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The options should be available through the interface")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The options should be available through the interface")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testBinaryStoreParametersNoConfigurationNoOptions() {
        storeParameters = .Binary(URL: localURL, configuration: nil, options: nil)
        switch storeParameters! {
        case .Binary(let URL, let configuration, let options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertEqual(storeParameters.URL()!, localURL, "The URL should be available through the interface")
            XCTAssertTrue(configuration == nil, "The store parameters should not have a configuration")
            XCTAssertTrue(storeParameters.configuration() == nil, "The configuration should be available through the interface")
            XCTAssertTrue(options == nil, "The store parameters should not have any options")
            XCTAssertTrue(storeParameters.options() == nil, "The options should be available through the interface")
            XCTAssertEqual(storeParameters.storeType(), NSBinaryStoreType, "The store type should be binary")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

    func testBinaryStoreParametersWithConfigurationAndOptions() {
        storeParameters = .Binary(URL: localURL, configuration: sampleConfiguration, options: sampleOptions)
        switch storeParameters! {
        case .Binary(let URL, let configuration, var options):
            XCTAssertEqual(URL, localURL, "The store should use the provided URL")
            XCTAssertEqual(configuration!, sampleConfiguration, "The store parameters should use the provided configuration")
            XCTAssertEqual(storeParameters.configuration()!, sampleConfiguration, "The configuration should be available through the interface")
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The store parameters should use the provided options")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The store parameters should use the provided options")
            options = storeParameters.options()!
            XCTAssertEqual(options!["alpha"] as String, "bravo", "The options should be available through the interface")
            XCTAssertEqual(options!["charlie"] as String, "delta", "The options should be available through the interface")

        default:
            XCTFail("There should not be another type of store parameters created")
        }
    }

}
