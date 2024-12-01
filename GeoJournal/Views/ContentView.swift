//
//  ContentView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Create Entry", systemImage: "note.text.badge.plus") {
                CreateEntryView()
            }
            
            Tab("View Entries", systemImage: "list.bullet") {
                EntriesView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EntryViewModel())
}
