//
//  CoreDataManager.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                print("An error occurred while loading persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func getEntries() -> [Entry] {
        var cdEntries = [CDEntry]()
        let request = NSFetchRequest<CDEntry>(entityName: "CDEntry")
        
        do {
            cdEntries = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("An error occurred while reading entries from memory: \(error)")
        }
        
        return cdEntries.map { $0.toEntry() }
    }
    
    @discardableResult
    func createCDEntry(from entry: Entry) -> CDEntry {
        let cdEntry = CDEntry(context: persistentContainer.viewContext)
        
        cdEntry.id = entry.id
        cdEntry.title = entry.title
        cdEntry.note = entry.description
        cdEntry.timestamp = entry.timestamp
        cdEntry.lat = entry.location.coordinate.latitude
        cdEntry.lon = entry.location.coordinate.longitude
        saveChanges()
        
        return cdEntry
    }
    
    private func saveChanges() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("An error occurred while saving changes to Core Data: \(error)")
            }
        }
    }
}
