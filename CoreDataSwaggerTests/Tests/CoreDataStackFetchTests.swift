//
//  CoreDataStackFetchTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class CoreDataStackFetchTests: XCTestCase {

    var stack: CoreDataStack!
    var request: NSFetchRequest!
    var results: [NSManagedObject]?
    var error: NSError?

    var apple: Fruit!
    var banana: Fruit!
    var lettuce: Vegetable!

    override func setUp() {
        super.setUp()

        let bundles = NSBundle.allBundles() as [NSBundle]
        let modelSource = CoreDataModelSource(bundles: bundles)
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
        createProduce()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func createProduce() {
        apple = Fruit(name: "Apple", color: "red", context: stack.context)
        banana = Fruit(name: "Banana", color: "yellow", context: stack.context)
        lettuce = Vegetable(name: "Lettuce", color: "green", context: stack.context)
    }

    func testSuccessfulFetchRequest() {
        request = NSFetchRequest(entityName: "Produce")
        (results, error) = stack.fetch(request)
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(results != nil, "There should be fetch results returned")
        XCTAssertEqual(results!.count, 3, "There should be three objects returned")
        XCTAssertTrue(contains(results!, apple), "The apple should be included in the results")
        XCTAssertTrue(contains(results!, banana), "The banana should be included in the results")
        XCTAssertTrue(contains(results!, lettuce), "The lettuce should be included in the results")
    }

    func testFailingFetchRequest() {
        request = NSFetchRequest(entityName: "Car")
        (results, error) = stack.fetch(request)
        XCTAssertTrue(error != nil, "There should be an error returned")
        XCTAssertTrue(results == nil, "There should be no fetch results returned")
    }

}
