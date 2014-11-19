//
//  NSManagedObjectExtensions.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/18/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension NSManagedObject {

    /**
      Class method for retrieving the associated entity description from a stack's managed object model.
      @param        inStack `CoreDataStack` with the model to search
      @return       Entity description associated with the custom managed object subclass, if found.  Nil is returned if an entity is not found or if the base class is used.
    */
    public class func entity(inStack stack: CoreDataStack) -> NSEntityDescription? {
        if self.isMemberOfClass(NSManagedObject) {
            return nil
        }

        for entity in stack.model.entities as [NSEntityDescription] {
            if entity.managedObjectClassName == NSStringFromClass(self) {
                return entity
            }
        }

        return nil
    }

}
