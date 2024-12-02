//
//  PostsView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI

struct EntriesView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    
    @State var showMapView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showMapView {
                    EntriesMapView()
                } else {
                    EntriesListView()
                }
                
                VStack {
                    Spacer()
                    
                    Toggle("\(showMapView ? "View List" : "View Map")", isOn: $showMapView)
                        .toggleStyle(.button)
                }
            }
        }
    }
}
