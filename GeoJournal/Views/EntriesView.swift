//
//  PostsView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI

struct EntriesView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.entries) { entry in
                NavigationLink(entry.title, destination: EntryDetailView(entry: entry))
            }
            .navigationTitle("Entries")
        }
    }
}
