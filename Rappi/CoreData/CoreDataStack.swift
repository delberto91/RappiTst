//
//  CoreDataStack.swift
//  Rappi
//
//  Created by Delberto Martinez on 5/19/19.
//  Copyright © 2019 Delberto Martinez. All rights reserved.
//

import UIKit
import CoreData
class CoreDataStack: NSObject {

    //handles coreData Stack 
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CoreData 
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
     func createEntity(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let popularEntity = NSEntityDescription.insertNewObject(forEntityName: "MovieDataModel", into: context) as? MovieDataModel {
            popularEntity.title = dictionary["title"] as? String
            popularEntity.overview = dictionary["overview"] as? String
            popularEntity.poster_path = dictionary["poster_path"] as? String
            popularEntity.vote_average = dictionary["vote_average"] as? String
            popularEntity.original_language = dictionary["original_language"] as? String
            popularEntity.release_date = dictionary["release_date"] as? String
            
            return popularEntity
        }
        return nil
    }

     func saveInCoreDataWith(array: [[String: AnyObject]]) {
        for dict in array {
            _ = self.createEntity(dictionary: dict)
        }
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    
     func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDataModel")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }



    

}
