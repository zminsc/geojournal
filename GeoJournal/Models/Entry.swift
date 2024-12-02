//
//  Entry.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import CoreLocation
import Foundation

struct Entry: Identifiable, Hashable {
    var title: String
    var description: String
    let location: CLLocation
    let id: UUID
    let timestamp: Date
    let photos: [Data]

    init(title: String, description: String, location: CLLocation, photos: [Data] = [], id: UUID = UUID(), timestamp: Date = Date()) {
        self.title = title
        self.description = description
        self.location = location
        self.photos = photos
        self.id = id
        self.timestamp = timestamp
    }
}
