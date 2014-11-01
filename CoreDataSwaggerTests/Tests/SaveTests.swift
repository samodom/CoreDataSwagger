//
//  SaveTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import XCTest
import CoreData

class SaveTests: XCTestCase {

    var stack: CoreDataStack!
    var fruit: Fruit!
    var success = false
    var error: NSError?

    override func setUp() {
        super.setUp()

        let bundles = NSBundle.allBundles() as [NSBundle]
        let modelSource = CoreDataModelSource(bundles: bundles)
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
        fruit = Fruit(name: "Apple", color: "red", context: stack.context)
    }
    
    override func tearDown() {
        stack = nil
        fruit = nil

        super.tearDown()
    }

    func testSuccessfulContextSave() {
        fruit.name = "Orange"
        fruit.color = "orange"
        (success, error) = stack.save()
        XCTAssertTrue(success, "The save should indicate success")
        XCTAssertFalse(stack.context.hasChanges, "The context should no longer have changes")
        XCTAssertFalse(fruit.hasChanges, "The object should no longer have changes")
        XCTAssertTrue(error == nil, "The error should be nil")
    }

    func testFailingContextSave() {
        fruit.name = "Orange"
        fruit.color = nil
        (success, error) = stack.save()
        XCTAssertFalse(success, "The save should indicate failure")
        XCTAssertTrue(stack.context.hasChanges, "The context should still have changes")
        XCTAssertTrue(fruit.hasChanges, "The object should still have changes")
        XCTAssertFalse(error == nil, "The error should not be nil")
    }

    func testSuccessfulSynchronousSave() {
        (success, error) = stack.save() {
            self.fruit.name = "Orange"
            self.fruit.color = "orange"
        }
        XCTAssertTrue(success, "The save should indicate success")
        XCTAssertFalse(stack.context.hasChanges, "The context should no longer have changes")
        XCTAssertFalse(fruit.hasChanges, "The object should no longer have changes")
        XCTAssertTrue(error == nil, "The error should be nil")
    }

    func testFailingSynchronousSave() {
        (success, error) = stack.save() {
            self.fruit.name = "Orange"
            self.fruit.color = nil
        }
        XCTAssertFalse(success, "The save should indicate failure")
        XCTAssertTrue(stack.context.hasChanges, "The context should still have changes")
        XCTAssertTrue(fruit.hasChanges, "The object should still have changes")
        XCTAssertFalse(error == nil, "The error should be nil")
    }

}
