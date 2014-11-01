//
//  CoreDataStackEntities.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension CoreDataStack {

    /**
      Provides all entities in the stack's managed object model.
      @return       Entity description objects for all entities contained in this stack's managed object model
    */
    public var entities: [NSEntityDescription] {
        return model.entities as [NSEntityDescription]
    }

    /**
      Provides all entities in the stack's managed object model.
      @return       Entity description objects for all entities contained in this stack's managed object model.
    */
    public var entitiesByName: [String:NSEntityDescription] {
        return model.entitiesByName as [String:NSEntityDescription]
    }

    /**
      Searches for an entity in the stack's managed object context by name.
      @param named  Name of an entity to find.
      @return       Entity description with name matching the provided name in the stack's managd object context, if it exists.
    */
    public func entity(named name: String) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(name, inManagedObjectContext: context)
    }

    /**
      Searches for an entity in the stack's managed object context by name and, if one is found, returns its properties.
      @param named  Name of an entity to find.
      @return       Property descriptions for an entity with name matching the provided name in the stack's managd object context, if that entity exists.
    */
    public func propertiesForEntity(named entityName: String) -> [NSPropertyDescription]? {
        let entity = self.entity(named: entityName)
        return entity?.properties as? [NSPropertyDescription]
    }

    /**
    Searches for an entity in the stack's managed object context by name and, if one is found, returns its properties as a dictionary.
      @param named  Name of an entity to find.
      @return       Dictionary of property descriptions for an entity with name matching the provided name in the stack's managd object context, if that entity exists.
    */
    public func propertiesByNameForEntity(named entityName: String) -> [String:NSPropertyDescription]? {
        let entity = self.entity(named: entityName)
        return entity?.propertiesByName as? [String:NSPropertyDescription]
    }

}
