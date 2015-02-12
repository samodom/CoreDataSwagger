//
//  FetchedResultsControllerTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import UIKit
import XCTest

class FetchedResultsControllerTests: XCTestCase {

    var stack: CoreDataStack!
    var sectionedResults: NSFetchedResultsController!
    var flattenedResults: NSFetchedResultsController!
    var pathTo_0_0 = NSIndexPath(forRow: 0, inSection: 0)
    var pathTo_2_1 = NSIndexPath(forRow: 1, inSection: 2)

    override func setUp() {
        super.setUp()

        let model = LoadModel(named: "Produce")
        let modelSource = CoreDataModelSource(models: [model])
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
        createSampleFruit()
        createControllers()
    }

    override func tearDown() {
        super.tearDown()
    }

    private func createControllers() {
        var fetchRequest = NSFetchRequest(entityName: "Fruit")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        flattenedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        flattenedResults.performFetch(nil)

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "color", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        sectionedResults = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: "color", cacheName: nil)
        sectionedResults.performFetch(nil)
    }

    private func createSampleFruit() {
        stack.save() {
            let context = self.stack.context
            Fruit(name: "Apple", color: "red", context: context)
            Fruit(name: "Banana", color: "yellow", context: context)
            Fruit(name: "Cherry", color: "red", context: context)
            Fruit(name: "Kiwi", color: "green", context: context)
            Fruit(name: "Lime", color: "green", context: context)
            Fruit(name: "Pineapple", color: "yellow", context: context)
        }
    }
    
    func testItemSubscriptForObject() {
        var fruit = flattenedResults[3] as! Fruit
        XCTAssertEqual(fruit.name, "Kiwi", "The object at the specified row index should be returned using the first section")
        fruit = sectionedResults[1] as! Fruit
        XCTAssertEqual(fruit.name, "Lime", "The object at the specified row index should be returned using the first section")
    }

    func testIndexPathSubscriptForObject() {
        var fruit = flattenedResults[pathTo_0_0] as! Fruit
        XCTAssertEqual(fruit.name, "Apple", "The object at the specified index path should be returned")
        fruit = sectionedResults[pathTo_2_1] as! Fruit
        XCTAssertEqual(fruit.name, "Pineapple", "The object at the specified index path should be returned")
    }

}
