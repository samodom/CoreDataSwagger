CoreDataSwagger
===============

Extensions to CoreData providing a unified stack with configuration options and a simpler interface to common operations.

### Unified Stack

Use a simpler interface to the various components of a CoreData implementation instead of fooling around with separate pieces.

Want a managed object model that is merged from all of the models in your main bundle?  And a persistent store coordinator with a single in-memory store using that model?  And a managed object context using private queue concurrency against that coordinator?  **Boom!**
```swift
var stack = CoreDataStack()
```

Want a managed object model that uses specific models and store metadata?  And you've got two different stores and need main queue concurrency?  Only a few lines of Swagger code needed.
```swift
let modelSource = CoreDataModelSource(models: [modelOne, modelTwo], metadata: metadata)
let inMemoryStore = CoreDataStoreParameters()
let sqliteStore = CoreDataStoreParameters.SQLite(URL: storeURL, configuration: "Custom", options: nil)
let configuration = CoreDataStackConfiguration(concurrency: .MainQueueConcurrencyType, modelSource: modelSource, storeParameters: [inMemoryStore, sqliteStore])
var stack = CoreDataStack(configuration: configuration)
```


### Simpler Fetch Results

You no longer need to provide error pointers to get fetch errors (currently not working - bug filed with Apple).  All you need to do is use or ignore the error value in the tuple returned from a fetch.  The return values are mutually exclusive

*Managed Object Fetches*
`CoreDataStack.fetch()` returns `[NSManagedObject]?` and `NSError`
```swift
let fetchRequest = ...
(let results, let error) = stack.fetch(fetchRequest)
```

*Managed Object ID Fetches*
`CoreDataStack.fetchIDs()` returns `[NSManagedObjectID]?` and `NSError`
```swift
let fetchRequest = ...
(let results, let error) = stack.fetchIDs(fetchRequest)
```

*Object Dictionary Fetches*
`CoreDataStack.fetchDictionaries()` returns `[AnyObject]?` and `NSError`
```swift
let fetchRequest = ...
(let results, let error) = stack.fetchDictionaries(fetchRequest)
```

*Object Count Fetches*
`CoreDataStack.count()` returns `UInt?` and `NSError`
```swift
let fetchRequest = ...
(let results, let error) = stack.count(fetchRequest)
```


### Simpler Save and Perform Block And Wait

Saving changes to the managed object context is as easy as always, but now you don't have to provide an error pointer.  The save() method returns both a success flag and an optional error.
```swift
(let success, let error) = stack.save()
```

Additionally, you can provide a closure to the save() method that will be executed before the save in a synchronous block via performBlockAndWait().
```swift
(let success, let error) = stack.save() {
    managedObject.property = "new value"
}
```


### Entity and Property Retrieval

Find entities and their properties from the stack's more strongly-typed interface:
- `var entities: [NSEntityDescription]`
- `var entitiesByName: [String:NSEntityDescription]`
- `func entity(named name: String) -> NSEntityDescription?`
- `func propertiesForEntity(named entityName: String) -> [NSPropertyDescription]?`
- `func propertiesByNameForEntity(named entityName: String) -> [String:NSPropertyDescription]?`
