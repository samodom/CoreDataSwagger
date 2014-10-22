//
//  BasicCoreDataStackTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/12/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class BasicCoreDataStackTests: XCTestCase {

    let datastoreFilename = "sampledatastore.sqlite"
    var datastoreURL: NSURL!
    var stack: CoreDataStack!

    override func setUp() {
        super.setUp()

        datastoreURL = URLofDocumentInDocumentsDirectory(named: datastoreFilename)
        deleteFile(atURL: datastoreURL)

        stack = CoreDataStack(datastoreURL: datastoreURL)
    }
    
    override func tearDown() {
        deleteFile(atURL: datastoreURL)

        super.tearDown()
    }

    func testCanCreateCoreDataStackWithURL() {
        XCTAssertTrue(stack != nil, "Should be able to create a new core data stack with a file URL")
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(datastoreURL.path!)
        XCTAssertTrue(fileExists, "A new datastore should be created if one exists")
    }

    func testCoreDataStackHasPersistentStoreCoordinator() {
        let coordinator = stack.coordinator
        XCTAssertEqual(coordinator.managedObjectModel, stack.model, "The persistent store should use the same model as the stack")
        let allStores = coordinator.persistentStores as [NSPersistentStore]
        XCTAssertEqual(allStores.count, 1, "There should only be one persistent store")
        let store = allStores.first!
        XCTAssertEqual(store.type, NSSQLiteStoreType, "The store type should be SQLite when persistent")
    }

    func testCoreDataStackHasMergedManagedObjectModel() {
        let model = stack.model
        let entities = model.entitiesByName as [String:NSEntityDescription]
        XCTAssertEqual(entities.count, 3, "There should be two different entities merged from two different models")
        XCTAssertTrue(entities["EntityOne"] != nil, "An entity named 'EntityOne' should be included in the merged model")
        XCTAssertTrue(entities["EntityTwo"] != nil, "An entity named 'EntityTwo' should be included in the merged model")
        XCTAssertTrue(entities["Fruit"] != nil, "An entity named 'Fruit' should be included in the merged model")
    }

    func testCoreDataStackHasRootManagedObjectContext() {
        let context = stack.rootContext
        XCTAssertTrue(context.parentContext == nil, "The root context should not have a parent context")
        XCTAssertEqual(context.concurrencyType, NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType, "The concurrency should be the main queue type")
        XCTAssertEqual(context.persistentStoreCoordinator!, stack.coordinator, "The context's persistent store coordinator should be the same as the stack's")
    }

    func testCanCreateCoreDataStackWithMemoryStore() {
        deleteFile(atURL: datastoreURL)
        stack = CoreDataStack()
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(datastoreURL.path!)
        XCTAssertFalse(fileExists, "Should be able to create an in-memory datastore")
        let allStores = stack.coordinator.persistentStores as [NSPersistentStore]
        XCTAssertEqual(allStores.count, 1, "There should only be one store")
        let store = allStores.first!
        XCTAssertEqual(store.type, NSInMemoryStoreType, "The store type should be in-memory")
    }

}

func URLofDocumentInDocumentsDirectory(named filename: String) -> NSURL? {
    return NSURL(string: filename, relativeToURL: documentsDirectoryURL)
}

var documentsDirectoryURL: NSURL {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let basePath = paths[0] as String
    return NSURL(fileURLWithPath: basePath)!
}

func deleteFile(atURL URL: NSURL) {
    let fileManager = NSFileManager.defaultManager()
    if !URL.fileURL {
        return
    }

    let filePath = URL.path!
    if fileManager.fileExistsAtPath(filePath) {
        fileManager.removeItemAtPath(filePath, error: nil)
    }
}
