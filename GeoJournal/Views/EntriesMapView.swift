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
    
    var body: some View {
        Map {
            ForEach(viewModel.entries) { entry in
                Marker(entry.title, coordinate: entry.location.coordinate)
            }
        }
        .navigationTitle("Entries")
    }
}
