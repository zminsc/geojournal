//
//  EntryDetailView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI

struct EntryDetailView: View {
    var entry: Entry

    var body: some View {
        List {
            Section(header: Text("Entry Details")) {
                Text("Title: \(entry.title)")
                Text("Description: \(entry.description)")
                Text("Location: \(entry.location.coordinate.latitude), \(entry.location.coordinate.longitude)")
                Text("Date: \(entry.timestamp, formatter: dateFormatter)")
            }
            
            if !entry.photos.isEmpty {
                Section(header: Text("Photos")) {
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
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle("Entry Details", displayMode: .inline)
    }
}

// Helper to format the date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()
