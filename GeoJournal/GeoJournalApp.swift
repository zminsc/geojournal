//
//  GeoJournalApp.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//
envimport SwiftUI

@main
struct GeoJournalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(EntryViewModel())
        }
    }
}
