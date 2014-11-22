//
//  NSFetchedResultsControllerExtensions.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 11/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public extension NSFetchedResultsController {

    /**
      Row/item index-based subscripting for controllers with fetch requests that return managed objects (as opposed to dictionaries or object identifiers).
      @param        item Index of row or item in the first section (0) of the results.
      @return       Managed object in the first section at the specified index.
    */
    public subscript(item: Int) -> NSManagedObject {
        let indexPath = NSIndexPath(forItem: item, inSection: 0)
        return objectAtIndexPath(indexPath) as NSManagedObject
    }

    /**
      Index path-based subscripting for controllers with fetch requests that return managed objects (as opposed to dictionaries or object identifiers).
      @param        indexPath Index path of managed object in the results.
      @return       Managed object at the specified index path.
    */
    public subscript(indexPath: NSIndexPath) -> NSManagedObject {
        return objectAtIndexPath(indexPath) as NSManagedObject
    }

}
