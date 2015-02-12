//
//  EntityTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class EntityTests: XCTestCase {

    var stack: CoreDataStack!

    override func setUp() {
        super.setUp()

        let model = LoadModel(named: "Produce")
        let modelSource = CoreDataModelSource(models: [model])
        let configuration = CoreDataStackConfiguration(modelSource: modelSource)
        stack = CoreDataStack(configuration: configuration)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    private class BadEntity: NSManagedObject {

    }

    func testAllEntitiesRetrieval() {
        let allEntities = stack.entities
        XCTAssertEqual(allEntities.count, 3, "There should be three total entities returned")
    }

    func testAllEntitiesByNameRetrieval() {
        let allEntities = stack.entitiesByName
        XCTAssertEqual(allEntities.count, 3, "There should be three total entities returned")
    }

    func testSuccessfulEntityByNameRetrieval() {
        let entity = stack.entity(named: "Fruit")
        XCTAssertTrue(entity != nil, "An entity description should be returned")
        XCTAssertEqual(entity!.name!, "Fruit", "The correct entity description should be retrieved")
    }

    func testFailingEntityByNameRetrieval() {
        let entity = stack.entity(named: "Car")
        XCTAssertTrue(entity == nil, "No entity description should be returned")
    }

    func testAllPropertiesRetrieval() {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: stack.context)!
        let expectedProperties = entity.properties as! [NSPropertyDescription]
        let properties = stack.propertiesForEntity(named: "Fruit")
        XCTAssertEqual(properties!, expectedProperties, "The properties of the entity described by the provided name should be returned")
    }

    func testPropertiesByNameRetrieval() {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: stack.context)!
        let expectedProperties = entity.propertiesByName as! [String:NSPropertyDescription]
        let properties = stack.propertiesByNameForEntity(named: "Fruit")
        XCTAssertEqual(properties!, expectedProperties, "The dictionary of properties of the entity described by the provided name should be returned")
    }

    func testSuccessfulEntityForClassRetrieval() {
        let entity = Fruit.entity(inStack: stack)
        XCTAssertEqual(entity!.name!, "Fruit", "The entity for the class should be retrieved from the stack's managed object model")
    }

    func testFailingEntityForClassRetrieval() {
        let entity = BadEntity.entity(inStack: stack)
        XCTAssertTrue(entity == nil, "No entity should be returned if it does not exist in the model")
    }

    func testBaseClassEntityForClassRetrieval() {
        let entity = NSManagedObject.entity(inStack: stack)
        XCTAssertTrue(entity == nil, "No entity should be returned for the base managed object class")
    }

    func testSuccessfulPropertiesForClassRetrieval() {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: stack.context)!
        let expectedProperties = entity.properties as! [NSPropertyDescription]
        let properties = Fruit.properties(inStack: stack)
        XCTAssertEqual(properties!, expectedProperties, "The properties of the entity associated with the class should be returned")
    }

    func testFailingPropertiesForClassRetrieval() {
        let properties = BadEntity.properties(inStack: stack)
        XCTAssertTrue(properties == nil, "No properties should be returned if the entity does not exist in the model")
    }

    func testBaseClassPropertiesForClassRetrieval() {
        let properties = NSManagedObject.properties(inStack: stack)
        XCTAssertTrue(properties == nil, "No properties should be returned for the base managed object class")
    }

    func testSuccessfulPropertiesByNameForClassRetrieval() {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: stack.context)!
        let expectedProperties = entity.propertiesByName as! [String:NSPropertyDescription]
        let properties = Fruit.propertiesByName(inStack: stack)
        XCTAssertEqual(properties!, expectedProperties, "The properties of the entity associated with the class should be returned")
    }

    func testFailingPropertiesByNameForClassRetrieval() {
        let properties = BadEntity.propertiesByName(inStack: stack)
        XCTAssertTrue(properties == nil, "No properties should be returned if the entity does not exist in the model")
    }

    func testBaseClassPropertiesByNameForClassRetrieval() {
        let properties = NSManagedObject.propertiesByName(inStack: stack)
        XCTAssertTrue(properties == nil, "No properties should be returned for the base managed object class")
    }

}
