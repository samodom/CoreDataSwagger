//
//  FetchTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class FetchTests: XCTestCase {

    var stack: CoreDataStack!
    var goodRequest: NSFetchRequest!
    var badRequest: NSFetchRequest!
    var objectResults: [NSManagedObject]?
    var objectIDResults: [NSManagedObjectID]?
    var dictionaryResults: [AnyObject]?
    var count: UInt?
    var error: NSError?

    var apple: Fruit!
    var banana: Fruit!
    var lettuce: Vegetable!

    override func setUp() {
        super.setUp()

        let model = LoadModel(named: "Produce")
        let modelSource = CoreDataModelSource(models: [model])
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
        createProduce()

        goodRequest = NSFetchRequest(entityName: "Produce")
        badRequest = NSFetchRequest(entityName: "Car")
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func createProduce() {
        stack.save() {
            let context = self.stack.context
            self.apple = Fruit(name: "Apple", color: "red", context: context)
            self.banana = Fruit(name: "Banana", color: "yellow", context: context)
            self.lettuce = Vegetable(name: "Lettuce", color: "green", context: context)
        }
    }

    func testSuccessfulManagedObjectFetchRequest() {
        (objectResults, error) = stack.fetch(goodRequest)
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(objectResults != nil, "There should be fetch results returned")
        XCTAssertEqual(objectResults!.count, 3, "There should be three objects returned")
        XCTAssertTrue(contains(objectResults!, apple), "The apple should be included in the results")
        XCTAssertTrue(contains(objectResults!, banana), "The banana should be included in the results")
        XCTAssertTrue(contains(objectResults!, lettuce), "The lettuce should be included in the results")
    }

    func testFailingManagedObjectFetchRequest() {
        (objectResults, error) = stack.fetch(badRequest)
        XCTAssertTrue(error != nil, "There should be an error returned")
        XCTAssertTrue(objectResults == nil, "There should be no fetch results returned")
    }

    func testSuccessfulManagedObjectIdentifierFetchRequest() {
        goodRequest.resultType = .ManagedObjectIDResultType
        (objectIDResults, error) = stack.fetchIDs(goodRequest)
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(objectIDResults != nil, "There should be fetch results returned")
        XCTAssertEqual(objectIDResults!.count, 3, "There should be three object identifiers returned")
        XCTAssertTrue(contains(objectIDResults!, apple.objectID), "The apple object identifier should be included in the results")
        XCTAssertTrue(contains(objectIDResults!, banana.objectID), "The banana object identifier should be included in the results")
        XCTAssertTrue(contains(objectIDResults!, lettuce.objectID), "The lettuce object identifier should be included in the results")
    }

    func testFailingManagedObjectIdentifierFetchRequest() {
        badRequest.resultType = .ManagedObjectIDResultType
        (objectIDResults, error) = stack.fetchIDs(badRequest)
        XCTAssertTrue(error != nil, "There should be an error returned")
        XCTAssertTrue(objectIDResults == nil, "There should be no fetch results returned")
    }

    func testSuccessfulDictionaryFetchRequest() {
        goodRequest.resultType = .DictionaryResultType
        goodRequest.propertiesToFetch = GetNameAndColorProperties(inContext: stack.context)
        goodRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        (dictionaryResults, error) = stack.fetchDictionaries(goodRequest)
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(dictionaryResults != nil, "There should be fetch results returned")
        XCTAssertEqual(dictionaryResults!.count, 3, "There should be three objects returned")
        var values = dictionaryResults![0] as! [NSString:AnyObject]
        XCTAssertEqual(values["name"] as! String, "Apple", "The apple should be included in the results")
        XCTAssertEqual(values["color"] as! String, "red", "The apple should be included in the results")
        values = dictionaryResults![1] as! [NSString:AnyObject]
        XCTAssertEqual(values["name"] as! String, "Banana", "The banana should be included in the results")
        XCTAssertEqual(values["color"] as! String, "yellow", "The banana should be included in the results")
        values = dictionaryResults![2] as! [NSString:AnyObject]
        XCTAssertEqual(values["name"] as! String, "Lettuce", "The lettuce should be included in the results")
        XCTAssertEqual(values["color"] as! String, "green", "The lettuce should be included in the results")
    }

    func testFailingDictionaryFetchRequest() {
        badRequest.resultType = .DictionaryResultType
        badRequest.propertiesToFetch = GetNameAndColorProperties(inContext: stack.context)
        badRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        (dictionaryResults, error) = stack.fetchDictionaries(badRequest)
        XCTAssertTrue(error != nil, "There should be an error returned")
        XCTAssertTrue(dictionaryResults == nil, "There should be no fetch results returned")
    }

    func testSuccessfulCountFetchRequest() {
        goodRequest.resultType = .CountResultType
        (count, error) = stack.count(goodRequest)
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(count != nil, "There should be fetch result count returned")
        XCTAssertEqual(count!, UInt(3), "There should be three objects that would be returned in a fetch request")
    }

    func testFailingCountFetchRequest() {
        badRequest.resultType = .CountResultType
        (count, error) = stack.count(badRequest)
        XCTAssertTrue(error != nil, "There should be an error returned")
        XCTAssertTrue(count == nil, "There should be no fetch result count returned")
    }

    func testSuccessfulEntityNameFetch() {
        (objectResults, error) = stack.fetch("Fruit")
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(objectResults != nil, "There should be fetch results returned")
        XCTAssertEqual(objectResults!.count, 2, "There should be two objects returned")
        XCTAssertTrue(contains(objectResults!, apple), "The apple should be included in the results")
        XCTAssertTrue(contains(objectResults!, banana), "The banana should be included in the results")
    }

    func testFailingEntityNameFetch() {
        (objectResults, error) = stack.fetch("Car")
        XCTAssertTrue(error != nil, "There should be an error returned")
        XCTAssertTrue(objectResults == nil, "There should be no fetch results returned")
    }

    func testSuccessfulEntityDescriptionFetch() {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: stack.context)!
        (objectResults, error) = stack.fetch(entity)
        XCTAssertTrue(error == nil, "There should be no error returned")
        XCTAssertTrue(objectResults != nil, "There should be fetch results returned")
        XCTAssertEqual(objectResults!.count, 2, "There should be two objects returned")
        XCTAssertTrue(contains(objectResults!, apple), "The apple should be included in the results")
        XCTAssertTrue(contains(objectResults!, banana), "The banana should be included in the results")
    }
    
}

private func GetNameAndColorProperties(inContext context: NSManagedObjectContext) -> [NSPropertyDescription] {
    let nameProperty = GetProducePropertyDescription(named: "name", inContext: context)!
    let colorProperty = GetProducePropertyDescription(named: "color", inContext: context)!
    return [nameProperty, colorProperty]
}

private func GetProducePropertyDescription(named propertyName: String, inContext context: NSManagedObjectContext) -> NSPropertyDescription? {
    let entity = NSEntityDescription.entityForName("Produce", inManagedObjectContext: context)
    return entity!.propertiesByName[propertyName] as? NSPropertyDescription
}
