//
//  DeleteTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class DeleteTests: XCTestCase {

    var stack: CoreDataStack!
    var apple: Fruit!
    var banana: Fruit!
    var kiwi: Fruit!
    var lettuce: Vegetable!

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
            let context = self.stack.context
            self.apple = Fruit(name: "Apple", color: "red", context: context)
            self.banana = Fruit(name: "Banana", color: "yellow", context: context)
            self.kiwi = Fruit(name: "kiwi", color: "green", context: context)
            self.lettuce = Vegetable(name: "lettuce", color: "green", context: context)
        }
    }

    func testObjectDeletion() {
        stack.delete(apple)
        XCTAssertTrue(apple.hasChanges, "The object should indicate having changes and should be deleted on the next save")
        XCTAssertTrue(stack.context.hasChanges, "The context should not be saved after the deletion")
    }

    func testObjectArrayDeletion() {
        stack.delete([apple, kiwi])
        XCTAssertTrue(apple.hasChanges, "The object should indicate having changes and should be deleted on the next save")
        XCTAssertTrue(kiwi.hasChanges, "The object should indicate having changes and should be deleted on the next save")
        XCTAssertFalse(banana.hasChanges, "The object should not indicate having changes")
        XCTAssertFalse(lettuce.hasChanges, "The object should not indicate having changes")
        XCTAssertTrue(stack.context.hasChanges, "The context should not be saved after the deletion")
    }

    func testDeletionByObjectIdentifier() {
        stack.delete(apple.objectID)
        XCTAssertTrue(apple.hasChanges, "The object should indicate having changes and should be deleted on the next save")
        XCTAssertTrue(stack.context.hasChanges, "The context should not be saved after the deletion")
    }

    func testDeletionByObjectIdentifierArray() {
        stack.delete([apple.objectID, kiwi.objectID])
        XCTAssertTrue(apple.hasChanges, "The object should indicate having changes and should be deleted on the next save")
        XCTAssertTrue(kiwi.hasChanges, "The object should indicate having changes and should be deleted on the next save")
        XCTAssertFalse(banana.hasChanges, "The object should not indicate having changes")
        XCTAssertFalse(lettuce.hasChanges, "The object should not indicate having changes")
        XCTAssertTrue(stack.context.hasChanges, "The context should not be saved after the deletion")
    }

    func testDeletionOfObjectFetchResults() {
        let fetchRequest = NSFetchRequest(entityName: "Fruit")
        stack.delete(fetchRequest)
        XCTAssertTrue(apple.hasChanges, "All Fruit entity objects should be marked for deletion")
        XCTAssertTrue(banana.hasChanges, "All Fruit entity objects should be marked for deletion")
        XCTAssertTrue(kiwi.hasChanges, "All Fruit entity objects should be marked for deletion")
        XCTAssertFalse(lettuce.hasChanges, "Only Fruit entity objects should be marked for deletion")
        XCTAssertTrue(stack.context.hasChanges, "The context should not be saved after the deletion")
    }

    func testDeletionOfObjectIDFetchResults() {
        let fetchRequest = NSFetchRequest(entityName: "Fruit")
        fetchRequest.resultType = .ManagedObjectIDResultType
        stack.delete(fetchRequest)
        XCTAssertTrue(apple.hasChanges, "All Fruit entity objects should be marked for deletion")
        XCTAssertTrue(banana.hasChanges, "All Fruit entity objects should be marked for deletion")
        XCTAssertTrue(kiwi.hasChanges, "All Fruit entity objects should be marked for deletion")
        XCTAssertFalse(lettuce.hasChanges, "Only Fruit entity objects should be marked for deletion")
        XCTAssertTrue(stack.context.hasChanges, "The context should not be saved after the deletion")
    }

}
