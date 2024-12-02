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
            CreateEntryView()
                .tabItem {
                    Label("Create Entry", systemImage: "note.text.badge.plus")
                }
            
            EntriesView()
                .tabItem {
                    Label("View Entries", systemImage: "list.bullet")
                }

//            Tab("Create Entry", systemImage: "note.text.badge.plus") {
//            }
//            
//            Tab("View Entries", systemImage: "list.bullet") {
//                EntriesView()
//            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(EntryViewModel())
}
