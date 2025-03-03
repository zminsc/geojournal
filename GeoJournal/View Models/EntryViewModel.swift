//
//  EntryViewModel.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import CoreLocation
import Foundation

class EntryViewModel: ObservableObject {
    @Published var entries = [Entry]()
    
    var locationViewModel = LocationViewModel()
    var coreDataManager = CoreDataManager.shared
    
    init() {
        entries = coreDataManager.getEntries()
    }
    
    func createNewEntry(title: String, description: String, photos: [Data]) {
        if let location = locationViewModel.userLocation {
            let entry = Entry(title: title, description: description, location: location, photos: photos)
            coreDataManager.createCDEntry(from: entry)
            entries.append(entry)
        }
    }
    
    func updateEntry(entry: Entry, newTitle: String, newDescription: String) {
        if let entryIndex = entries.firstIndex(where: { $0.id == entry.id }) {
            coreDataManager.updateCDEntry(from: entry, newTitle: newTitle, newDescription: newDescription)
            entries[entryIndex].title = newTitle
            entries[entryIndex].description = newDescription
        }
    }
    
    func deleteEntry(entry: Entry) {
        if entries.contains(where: { $0.id == entry.id }) {
            coreDataManager.deleteCDEntry(from: entry)
            entries.removeAll { $0.id == entry.id }
        }
    }
    
    func distanceFromEntry(entry: Entry) -> Double {
        let userLocation = locationViewModel.userLocation!
        let entryLocation = entry.location
        return userLocation.distance(from: entryLocation)
    }
}
