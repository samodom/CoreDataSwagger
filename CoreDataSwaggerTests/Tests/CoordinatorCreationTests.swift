//
//  CoordinatorCreationTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/29/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class CoordinatorCreationTests: XCTestCase {

    var coordinator: NSPersistentStoreCoordinator!
    var model: NSManagedObjectModel!
    var storeParameters: [CoreDataStoreParameters]!
    var sqliteStoreURL: NSURL!
    var binaryStoreURL: NSURL!
    var timeoutOptions = [ NSPersistentStoreTimeoutOption: 3 ] as CoreDataStoreOptions

    override func setUp() {
        super.setUp()

        createModel()
        sqliteStoreURL = URLofDocumentInDocumentsDirectory(named: "datastore.sqlite")
        binaryStoreURL = URLofDocumentInDocumentsDirectory(named: "datastore.dat")
        createDefaultStoreParameters()
        createCustomStoreParameters()
    }
    
    override func tearDown() {
        super.tearDown()

        sqliteStoreURL = URLofDocumentInDocumentsDirectory(named: "datastore.sqlite")
        binaryStoreURL = URLofDocumentInDocumentsDirectory(named: "datastore.dat")
        DeleteFile(atURL: sqliteStoreURL)
        DeleteFile(atURL: binaryStoreURL)
    }

    func createModel() {
        let modelOne = LoadModel(named: "SampleModelOne")
        let modelTwo = LoadModel(named: "SampleModelTwo")
        model = NSManagedObjectModel(byMergingModels: [modelOne, modelTwo])
    }

    func createDefaultStoreParameters() {
        let storeOne = CoreDataStoreParameters()
        let storeTwo = CoreDataStoreParameters.SQLite(URL: sqliteStoreURL, configuration: nil, options: nil)
        let storeThree = CoreDataStoreParameters.Binary(URL: binaryStoreURL, configuration: nil, options: nil)
        storeParameters = [storeOne, storeTwo, storeThree]
    }

    func testCoordinatorCreationWithStores() {
        coordinator = NSPersistentStoreCoordinator.createWithModel(model, storeParameters: storeParameters)
        XCTAssertEqual(coordinator.managedObjectModel, model, "The coordinator should use the model provided")
        let stores = coordinator.persistentStores as [NSPersistentStore]
        XCTAssertEqual(stores.count, 3, "The coordinator should have three persistent stores")
        XCTAssertEqual(stores[0].type, NSInMemoryStoreType, "There should be an in-memory store created")
        XCTAssertEqual(stores[1].type, NSSQLiteStoreType, "There should be a SQLite store created")
        XCTAssertEqual(stores[1].URL!, sqliteStoreURL, "The SQLite store should use the provided URL")
        XCTAssertEqual(stores[2].type, NSBinaryStoreType, "There should be a binary store created")
        XCTAssertEqual(stores[2].URL!, binaryStoreURL, "The binary store should use the provided URL")
    }

    func testCoordinatorCreationWithBadStoreURL() {
        binaryStoreURL = NSURL(string: "http://www.example.com/")
        createDefaultStoreParameters()
        coordinator = NSPersistentStoreCoordinator.createWithModel(model, storeParameters: storeParameters)
        XCTAssertEqual(coordinator.managedObjectModel, model, "The coordinator should use the model provided")
        let stores = coordinator.persistentStores as [NSPersistentStore]
        XCTAssertEqual(stores.count, 2, "The coordinator should have two persistent stores")
        XCTAssertEqual(stores[0].type, NSInMemoryStoreType, "There should be an in-memory store created")
        XCTAssertEqual(stores[1].type, NSSQLiteStoreType, "There should be a SQLite store created")
        XCTAssertEqual(stores[1].URL!, sqliteStoreURL, "The SQLite store should use the provided URL")
    }

    func createCustomStoreParameters() {
        let storeOne = CoreDataStoreParameters.InMemory(configuration: "Alternate", options: timeoutOptions)
        let storeTwo = CoreDataStoreParameters.SQLite(URL: sqliteStoreURL, configuration: "Alternate", options: timeoutOptions)
        let storeThree = CoreDataStoreParameters.Binary(URL: binaryStoreURL, configuration: "Alternate", options: timeoutOptions)
        storeParameters = [storeOne, storeTwo, storeThree]
    }

    func testCoordinatorCreationWithCustomStores() {
        coordinator = NSPersistentStoreCoordinator.createWithModel(model, storeParameters: storeParameters)
        XCTAssertEqual(coordinator.managedObjectModel, model, "The coordinator should use the model provided")
        let allStores = coordinator.persistentStores as [NSPersistentStore]
        XCTAssertEqual(allStores.count, 3, "The coordinator should have three persistent stores")

        var store = allStores[0]
        XCTAssertEqual(store.type, NSInMemoryStoreType, "There should be an in-memory store created")
        XCTAssertEqual(store.configurationName, "Alternate", "The store should be created with the provided configuration")
        XCTAssertEqual(store.options![NSPersistentStoreTimeoutOption] as Int, 3, "The store should be created with the provided options")

        store = allStores[1]
        XCTAssertEqual(store.type, NSSQLiteStoreType, "There should be a SQLite store created")
        XCTAssertEqual(store.URL!, sqliteStoreURL, "The SQLite store should use the provided URL")
        XCTAssertEqual(store.configurationName, "Alternate", "The store should be created with the provided configuration")
        XCTAssertEqual(store.options![NSPersistentStoreTimeoutOption] as Int, 3, "The store should be created with the provided options")

        store = allStores[2]
        XCTAssertEqual(store.type, NSBinaryStoreType, "There should be a binary store created")
        XCTAssertEqual(store.URL!, binaryStoreURL, "The binary store should use the provided URL")
        XCTAssertEqual(store.configurationName, "Alternate", "The store should be created with the provided configuration")
        XCTAssertEqual(store.options![NSPersistentStoreTimeoutOption] as Int, 3, "The store should be created with the provided options")
    }

}
