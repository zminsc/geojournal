//
//  EntryDetailView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI
import MapKit

struct EntryDetailView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    @Environment(\.dismiss) var dismiss
    
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
                
                Button(role: .destructive) {
                    viewModel.deleteEntry(entry: entry)
                    dismiss()
                } label: {
                    Text("Delete entry")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                }
                .buttonStyle(.bordered)
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
