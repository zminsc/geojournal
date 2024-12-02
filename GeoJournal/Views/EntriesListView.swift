//
//  EntriesListView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/2/24.
//

import SwiftUI

struct EntriesListView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    
    @State var sortByDistance = false
    
    var sortedEntries: [Entry] {
        if sortByDistance {
            viewModel.entries.sorted { viewModel.distanceFromEntry(entry: $0) < viewModel.distanceFromEntry(entry: $1) }
        } else {
            viewModel.entries.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("Entries")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                
                Spacer()
                
                Menu {
                    Button(action: {
                        withAnimation {
                            sortByDistance.toggle()
                        }
                    }) {
                        Label(
                            sortByDistance ? "Sort by Recent" : "Sort by Distance",
                            systemImage: sortByDistance ? "clock" : "location"
                        )
                    }
                } label: {
                    Circle()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.blue)
                        .overlay(
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                }
            }
            .padding()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(sortedEntries) { entry in
                        NavigationLink(value: entry) {
                            EntryCardView(entry: entry)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationDestination(for: Entry.self) { entry in
            EntryDetailView(entry: entry)
        }
    }
}

struct EntryCardView: View {
    let entry: Entry

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(entry.timestamp, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(entry.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
            
            Spacer()
            
            if let imageData = entry.photos.first, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill() // Ensures the image fills the square frame
                    .frame(width: 80, height: 80) // Define square dimensions
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}
