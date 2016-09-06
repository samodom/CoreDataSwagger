//
//  ManagedObjectFetchTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class ManagedObjectFetchTests: XCTestCase {

    var stack: CoreDataStack!
    var error: NSError?

    private class WrongEntity: NSManagedObject {

    }

    override func setUp() {
        super.setUp()

        let model = LoadModel(named: "Produce")
        let modelSource = CoreDataModelSource(models: [model])
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
        createProduce()
    }
    
    override func tearDown() {
        super.tearDown()
    }


    func createProduce() {
        stack.save() {
            Fruit(name: "Apple", color: "red", context: self.stack.context)
            Fruit(name: "Banana", color: "yellow", context: self.stack.context)
            Vegetable(name: "Lettuce", color: "green", context: self.stack.context)
        }
    }

    func testManagedObjectClassDoesNotProvideFetchRequestWithWrongModel() {
        let fetchRequest = WrongEntity.fetchRequestWithStack(stack)
        XCTAssertNil(fetchRequest, "The managed object class should not provide a fetch request when using the wrong model")
    }

    func testManagedObjectClassProvidesFetchRequest() {
        let fetchRequest = Produce.fetchRequestWithStack(stack)!
        XCTAssertNotNil(fetchRequest, "The managed object class should provide a fetch request against the specified context")
        XCTAssertEqual(fetchRequest.entityName!, "Produce", "The fetch request should use the entity matching the class in the model")
        XCTAssertTrue(fetchRequest.includesSubentities, "The fetch request should include subentities by default")
        XCTAssertTrue(fetchRequest.predicate == nil, "The fetch request should not have a predicate")
        XCTAssertTrue(fetchRequest.sortDescriptors == nil, "The fetch request should not have any sort descriptors")
    }

    func testManagedObjectClassDoesNotFetchWithWrongModel() {
        var results: [WrongEntity]?
        var error: NSError?
        (results, error) = WrongEntity.fetchWithStack(stack)
        XCTAssertTrue(results == nil, "There should be no fetch results returned for an entity outside the stack's model")
        XCTAssertTrue(error != nil, "An error should be returned since the entity is not included in the model")
        XCTAssertEqual(error!.domain, CoreDataSwaggerErrorDomain, "The custom error domain should be used")
        XCTAssertEqual(error!.code, NSCoreDataError, "The error code should be the generic CoreData error code")
        println("User info: \(error!.userInfo)")
        XCTAssertEqual(error!.userInfo!.count, 0, "No user info should be attached to the error")
    }

    func testManagedObjectClassFetchesItsOwnKindWithSubentities() {
        var results: [Produce]?
        (results, error) = Produce.fetchWithStack(stack)
        XCTAssertTrue(error == nil, "No error should be returned")
        XCTAssertTrue(results != nil, "There should be fetch results returned")
        XCTAssertEqual(results!.count, 3, "All three produce items should be returned")
    }

    func testManagedObjectClassFetchesItsOwnKind() {
        var results: [Fruit]?
        (results, error) = Fruit.fetchWithStack(stack)
        XCTAssertTrue(error == nil, "No error should be returned")
        XCTAssertTrue(results != nil, "There should be fetch results returned")
        XCTAssertEqual(results!.count, 2, "Both fruit items should be returned")
    }

}
