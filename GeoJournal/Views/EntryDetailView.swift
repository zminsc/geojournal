//
//  EntryDetailView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI
import MapKit

struct EntryDetailView: View {
    var entry: Entry
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.title)
                    .bold()
                    .padding(.vertical, 4)
                
                Text(entry.timestamp, formatter: dateFormatter)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text(entry.description)
                    .font(.body)
                    .padding(.bottom, 8)
                
                if !entry.photos.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(entry.photos, id: \.self) { photoData in
                                if let image = UIImage(data: photoData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                
                Map {
                    Marker(entry.title, coordinate: entry.location.coordinate)
                }
                .frame(height: 250)
            }
            .padding()
        }
    }
}

// Helper to format the date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()
