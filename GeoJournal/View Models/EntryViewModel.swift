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
    
    func distanceFromEntry(entry: Entry) -> Double {
        let userLocation = locationViewModel.userLocation!
        let entryLocation = entry.location
        return userLocation.distance(from: entryLocation)
    }
}
