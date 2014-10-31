//
//  Produce.swift
//  CoreDataSwagger
//
//  Created by Sam Odom on 10/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

import CoreData

public class Produce: NSManagedObject {
    @NSManaged var name: String!
    @NSManaged var color: String!
    private convenience init(name: String, color: String, entity: NSEntityDescription, context: NSManagedObjectContext) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.name = name
        self.color = color
    }
}

public class Fruit: Produce {
    public convenience init(name: String, color: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Fruit", inManagedObjectContext: context)!
        self.init(name: name, color: color, entity: entity, context: context)
    }
}

public class Vegetable: Produce {
    public convenience init(name: String, color: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Vegetable", inManagedObjectContext: context)!
        self.init(name: name, color: color, entity: entity, context: context)
    }
}
