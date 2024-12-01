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
    
    func createNewEntry(title: String, description: String) {
        if let location = locationViewModel.userLocation {
            let entry = Entry(title: title, description: description, location: location)
            coreDataManager.createCDEntry(from: entry)
            entries.append(entry)
        }
    }
}
