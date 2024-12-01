//
//  CreatePostView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI

struct CreateEntryView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    
    @State private var entryTitle = ""
    @State private var entryDescription = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Entry Details")) {
                    TextField("Title", text: $entryTitle)
                    TextField("Description", text: $entryDescription)
                }
                
                Button("Save Entry") {
                    viewModel.createNewEntry(title: entryTitle, description: entryDescription)
                    entryTitle = ""
                    entryDescription = ""
                }
            }
            .navigationTitle("Create Entry")
        }
    }
}
