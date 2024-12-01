//
//  CDEntryExtensions.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import CoreLocation
import Foundation

extension CDEntry {
    func toEntry() -> Entry {
        let location = CLLocation(latitude: self.lat, longitude: self.lon)
        
        return Entry(
            title: self.title!,
            description: self.note!,
            location: location,
            id: self.id!,
            timestamp: self.timestamp!
        )
    }
}
