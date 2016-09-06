//
//  FetchedResultsControllerTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class FetchedResultsControllerTests: XCTestCase {

    var stack: CoreDataStack!
    var results: NSFetchedResultsController?
    var error: NSError?

    override func setUp() {
        super.setUp()

        let model = LoadModel(named: "Produce")
        let modelSource = CoreDataModelSource(models: [model])
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
        createSampleFruit()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    private func createSampleFruit() {
        stack.save() {
            let context = self.stack.context
            Fruit(name: "Apple", color: "red", context: context)
            Fruit(name: "Banana", color: "yellow", context: context)
            Fruit(name: "Cherry", color: "red", context: context)
            Fruit(name: "Kiwi", color: "green", context: context)
            Fruit(name: "Pineapple", color: "yellow", context: context)
        }
    }

    func testDefaultSuccessfulFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: "Fruit")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        (results, error) = stack.results(fetchRequest)
        XCTAssertTrue(error == nil, "No error should be returned for a successful fetch")
        XCTAssertTrue(results != nil, "The stack should produce a fetched results controller with the fetch request if it is valid")
        XCTAssertEqual(results!.fetchRequest, fetchRequest, "The controller should use the provided fetch request")
        XCTAssertTrue(results!.delegate == nil, "The controller should not have a delegate by default")
        let fetchedObjects = results!.fetchedObjects
        XCTAssertTrue(fetchedObjects != nil, "The fetch request should be executed and the fetched objects should be populated")
        XCTAssertEqual(fetchedObjects!.count, 5, "There should be 5 fetched objects")
    }

    func testDefaultFailingFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: "Car")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        (results, error) = stack.results(fetchRequest)
        XCTAssertTrue(results == nil, "The stack should not produce a fetched results controller with an invalid fetch request")
        XCTAssertTrue(error != nil, "An error should be returned for a failing fetch")
    }

    func testCustomFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: "Fruit")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        (results, error) = stack.results(fetchRequest)
        XCTAssertTrue(error == nil, "No error should be returned for a successful fetch")
        XCTAssertTrue(results != nil, "The stack should produce a fetched results controller with the fetch request if it is valid")
        XCTAssertEqual(results!.fetchRequest, fetchRequest, "The controller should use the provided fetch request")
        XCTAssertTrue(results!.delegate == nil, "The controller should not have a delegate by default")
        let fetchedObjects = results!.fetchedObjects
        XCTAssertTrue(fetchedObjects != nil, "The fetch request should be executed and the fetched objects should be populated")
        XCTAssertEqual(fetchedObjects!.count, 5, "There should be 5 fetched objects")
    }

}
