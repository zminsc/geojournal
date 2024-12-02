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
        
        // Convert NSSet of CDPhoto to [Data]
        let photoDataArray: [Data] = (self.photos as? Set<CDPhoto>)?.compactMap { $0.photoData } ?? []

        return Entry(
            title: self.title ?? "Untitled",
            description: self.note ?? "",
            location: location,
            photos: photoDataArray,
            id: self.id ?? UUID(),
            timestamp: self.timestamp ?? Date()
        )
    }
}


