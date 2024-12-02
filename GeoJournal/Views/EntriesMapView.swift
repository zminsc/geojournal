//
//  EntriesMapView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/2/24.
//

import MapKit
import SwiftUI

struct EntriesMapView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    @State var selectedEntry: Entry? = nil
    
    var body: some View {
        Map {
            ForEach(viewModel.entries) {entry in
                Annotation(entry.title, coordinate: entry.location.coordinate) {
                    VStack {
                        Image(systemName: "pin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .onTapGesture {
                                selectedEntry = entry
                            }
                    }
                }
            }
        }
        .navigationTitle("Entries")
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry)
        }
    }
}
