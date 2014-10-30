//
//  ModelCreationTests.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/27/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData
import XCTest

class ModelCreationTests: XCTestCase {

    var model: NSManagedObjectModel!
    var source: CoreDataModelSource!
    var metadata: CoreDataStoreMetaData!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testModelCreationWithDefaultSource() {
        source = CoreDataModelSource()
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model creation should be created by merging the models from the main bundle")
        XCTAssertEqual(model.entities.count, 0, "There should be no entities in the model as there are no models in the main bundle")
    }

    func testModelCreationWithURLContents() {
        let URL = URLofFile(named: "Produce", ofType: "momd")!
        source = CoreDataModelSource(contentURL: URL)
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created for a valid model file URL")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 3, "The model produced should be the one at the specified URL")
        XCTAssertTrue(entities["Fruit"] != nil, "The model produced should be the one at the specified URL")
    }

    func testModelCreationWithMainBundleMergeNoMetadata() {
        source = CoreDataModelSource()
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model creation should be created by merging the models from the main bundle")
        XCTAssertEqual(model.entities.count, 0, "There should be no entities in the model as there are no models in the main bundle")
    }

    func testModelCreationWithMainBundleMergeAndMetadata() {
        metadata = CreateMainBundleMetadata()
        source = CoreDataModelSource(metadata: metadata)
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model == nil, "A model creation should be attempted by merging the models from the main bundle - there are no models in the main bundle here")
    }

    func testModelCreationWithBundleMergeNoMetadata() {
        let bundleOne = BundleForModel(named: "SampleModelOne")
        let bundleTwo = BundleForModel(named: "Produce")
        source = CoreDataModelSource(bundles: [bundleOne, bundleTwo])
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created by merging the models in the provided bundles")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 4, "There should be four total entities from the merged bundles")
        XCTAssertTrue(entities["EntityOne"] != nil, "The sole entity from the first model should be included")
        XCTAssertTrue(entities["Produce"] != nil, "The 'Produce' entity from the second model should be included")
        XCTAssertTrue(entities["Fruit"] != nil, "The 'Fruit' entity from the second model should be included")
        XCTAssertTrue(entities["Vegetable"] != nil, "The 'Vegetable' entity from the second model should be included")
    }

    func testModelCreationWithBundleMergeAndMetadata() {
        metadata = CreateSomeModelsMetadata()
        let bundleOne = BundleForModel(named: "SampleModelTwo")
        let bundleTwo = BundleForModel(named: "Produce")
        source = CoreDataModelSource(bundles: [bundleOne, bundleTwo], metadata: metadata)
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created by merging the models in the provided bundles using the provided metadata")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 4, "There should be four total entities from the merged bundles")
        XCTAssertTrue(entities["EntityTwo"] != nil, "The sole entity from the first model should be included")
        XCTAssertTrue(entities["Produce"] != nil, "The 'Produce' entity from the second model should be included")
        XCTAssertTrue(entities["Fruit"] != nil, "The 'Fruit' entity from the second model should be included")
        XCTAssertTrue(entities["Vegetable"] != nil, "The 'Vegetable' entity from the second model should be included")
    }

    func testModelCreationWithAllBundlesMergeNoMetadata() {
        source = CoreDataModelSource.AllBundlesMerge(metadata: nil)
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created by merging the models in all bundles")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 5, "There should be five total entities from all bundles")
        XCTAssertTrue(entities["EntityOne"] != nil, "The sole entity from the first model should be included")
        XCTAssertTrue(entities["EntityTwo"] != nil, "The sole entity from the second model should be included")
        XCTAssertTrue(entities["Produce"] != nil, "The 'Produce' entity from the second model should be included")
        XCTAssertTrue(entities["Fruit"] != nil, "The 'Fruit' entity from the second model should be included")
        XCTAssertTrue(entities["Vegetable"] != nil, "The 'Vegetable' entity from the second model should be included")
    }

    func testModelCreationWithAllBundlesMergeAndMetadata() {
        metadata = CreateAllBundlesMetadata()
        source = CoreDataModelSource.AllBundlesMerge(metadata: metadata)
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created by merging the models in all bundles using the provided metadata")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 5, "There should be five total entities from all bundles")
        XCTAssertTrue(entities["EntityOne"] != nil, "The sole entity from the first model should be included")
        XCTAssertTrue(entities["EntityTwo"] != nil, "The sole entity from the second model should be included")
        XCTAssertTrue(entities["Produce"] != nil, "The 'Produce' entity from the second model should be included")
        XCTAssertTrue(entities["Fruit"] != nil, "The 'Fruit' entity from the second model should be included")
        XCTAssertTrue(entities["Vegetable"] != nil, "The 'Vegetable' entity from the second model should be included")
    }

    func testModelCreationWithModelMergeNoMetadata() {
        let modelOne = LoadModel(named: "SampleModelOne")
        let modelTwo = LoadModel(named: "Produce")
        source = CoreDataModelSource(models: [modelOne, modelTwo])
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created by merging the provided models")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 4, "There should be four total entities from the merged models")
        XCTAssertTrue(entities["EntityOne"] != nil, "The sole entity from the first model should be included")
        XCTAssertTrue(entities["Produce"] != nil, "The 'Produce' entity from the second model should be included")
        XCTAssertTrue(entities["Fruit"] != nil, "The 'Fruit' entity from the second model should be included")
        XCTAssertTrue(entities["Vegetable"] != nil, "The 'Vegetable' entity from the second model should be included")
    }

    func testModelCreationWithModelMergeAndMetadata() {
        metadata = CreateSomeModelsMetadata()
        let modelOne = LoadModel(named: "SampleModelTwo")
        let modelTwo = LoadModel(named: "Produce")
        source = CoreDataModelSource(models: [modelOne, modelTwo], metadata: metadata)
        model = NSManagedObjectModel.createFromSource(source)
        XCTAssertTrue(model != nil, "A model should be created by merging the provided models using the provided metadata")
        let entities = model.entitiesByName
        XCTAssertEqual(entities.count, 4, "There should be four total entities from the merged models")
        XCTAssertTrue(entities["EntityTwo"] != nil, "The sole entity from the first model should be included")
        XCTAssertTrue(entities["Produce"] != nil, "The 'Produce' entity from the second model should be included")
        XCTAssertTrue(entities["Fruit"] != nil, "The 'Fruit' entity from the second model should be included")
        XCTAssertTrue(entities["Vegetable"] != nil, "The 'Vegetable' entity from the second model should be included")
    }

}

private func URLofFile(named filename: String, ofType type: String) -> NSURL? {
    for bundle in NSBundle.allBundles() as [NSBundle] {
        let URL = bundle.URLForResource(filename, withExtension: type)
        if URL != nil {
            return URL
        }
    }

    return nil
}

private func BundleForModel(named modelName: String) -> NSBundle! {
    let allBundles = NSBundle.allBundles() as [NSBundle]
    for bundle in allBundles {
        if bundle.bundleURL.path!.rangeOfString(modelName) != nil {
            return bundle
        }
    }

    return nil
}

private func LoadModel(named name: String) -> NSManagedObjectModel! {
    let URL = URLofFile(named: name, ofType: "momd")!
    return NSManagedObjectModel(contentsOfURL: URL)!
}

private func CreateMainBundleMetadata() -> CoreDataStoreMetaData {
    let model = NSManagedObjectModel.mergedModelFromBundles(nil)!
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    let store = coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)!
    return store.metadata
}

private func CreateSomeModelsMetadata() -> CoreDataStoreMetaData {
    let modelOne = LoadModel(named: "SampleModelTwo")
    let modelTwo = LoadModel(named: "Produce")
    let model = NSManagedObjectModel(byMergingModels: [modelOne, modelTwo])!
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    let store = coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)!
    return store.metadata
}

private func CreateAllBundlesMetadata() -> CoreDataStoreMetaData {
    let model = NSManagedObjectModel.mergedModelFromBundles(NSBundle.allBundles())
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
    let store = coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)!
    return store.metadata
}
