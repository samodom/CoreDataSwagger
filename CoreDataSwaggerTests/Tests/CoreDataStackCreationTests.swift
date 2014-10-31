//
//  CoreDataStackCreationTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class CoreDataStackCreationTests: XCTestCase {

    var stack: CoreDataStack!
    var storeURL: NSURL!

    override func setUp() {
        super.setUp()

        storeURL = URLofFileInDocumentsDirectory(named: "datastore.sqlite")!
        DeleteFile(atURL: storeURL)
    }
    
    override func tearDown() {
        DeleteFile(atURL: storeURL)

        super.tearDown()
    }

    func testDefaultStackCreation() {
        stack = CoreDataStack()
        XCTAssertTrue(stack != nil, "A stack should be created with the default configuration")
        XCTAssertEqual(stack.model.entities.count, 0, "There are no models in the main bundle, so the entity count should be zero")
        XCTAssertEqual(stack.coordinator.persistentStores.count, 1, "There should be one persistent store")
        XCTAssertEqual(stack.context.concurrencyType, NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType, "The default context concurrency type should be the private queue type")
        XCTAssertEqual(stack.context.persistentStoreCoordinator!, stack.coordinator, "The context should use the stack's coordinator")
    }

    func createModelSource() -> CoreDataModelSource {
        let modelOne = LoadModel(named: "SampleModelOne")
        let modelTwo = LoadModel(named: "SampleModelTwo")
        return CoreDataModelSource(models: [modelOne, modelTwo])
    }

    func createStoreParameters() -> [CoreDataStoreParameters] {
        let parametersOne = CoreDataStoreParameters()
        let parametersTwo = CoreDataStoreParameters.SQLite(URL: storeURL, configuration: nil, options: nil)
        return [parametersOne, parametersTwo]
    }

    func testCustomStackCreationNoMetadata() {
        let modelSource = createModelSource()
        let storeParameters = createStoreParameters()
        let configuration = CoreDataStackConfiguration(concurrency: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType, modelSource: modelSource, storeParameters: storeParameters)
        stack = CoreDataStack(configuration: configuration)
        XCTAssertTrue(stack != nil, "A stack should be created with the custom configuration")
        XCTAssertEqual(stack.model.entities.count, 2, "There should be two total entities across all of the models")
        XCTAssertEqual(stack.coordinator.persistentStores.count, 2, "There should be two total persistent stores created")
        XCTAssertEqual(stack.context.concurrencyType, NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType, "The stack should create a managed object context with the provided concurency type")
        XCTAssertEqual(stack.context.persistentStoreCoordinator!, stack.coordinator, "The context should use the stack's coordinator")
    }

}
