//
//  Entry.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import CoreLocation
import Foundation

struct Entry: Identifiable, Hashable {
    let title: String
    let description: String
    let location: CLLocation
    let id: UUID
    let timestamp: Date
    let image: Data?

    init(title: String, description: String, location: CLLocation, image: Data? = nil, id: UUID = UUID(), timestamp: Date = Date()) {
        self.title = title
        self.description = description
        self.location = location
        self.image = image
        self.id = id
        self.timestamp = timestamp
    }
}
