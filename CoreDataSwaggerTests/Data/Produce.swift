//
//  Produce.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public class Fruit: NSManagedObject {
    @NSManaged var name: String!
    @NSManaged var color: String!
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}

