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
            Toggle("Sort by Distance", isOn: $sortByDistance)
                .padding()
            
            List(sortedEntries) { entry in
                NavigationLink(entry.title, destination: EntryDetailView(entry: entry))
            }
        }
        .navigationTitle("Entries")
    }
}

#Preview {
    EntriesListView()
}
