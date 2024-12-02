//
//  EntryDetailView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI
import MapKit

struct EntryDetailView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage? = nil // To store the selected image
    @State private var isImageFullScreen: Bool = false // To control fullscreen view visibility

    var entry: Entry
    
    @State var isEditing = false
    @State var newTitle: String
    @State var newDescription: String
    
    init(entry: Entry) {
        self.entry = entry
        _newTitle = State(initialValue: entry.title)
        _newDescription = State(initialValue: entry.description)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                Group {
                    if isEditing {
                        TextField("Title", text: $newTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(newTitle)
                    }
                }
                .font(.title)
                .bold()
                .padding(.vertical, 4)
                
                Text(entry.timestamp, formatter: dateFormatter)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Group {
                    if isEditing {
                        TextField("Write a note...", text: $newDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text(newDescription)
                    }
                }
                .font(.body)
                .padding(.bottom, 8)
                
                if !entry.photos.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(entry.photos, id: \.self) { photoData in
                                if let image = UIImage(data: photoData) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            // Set the selected image and show fullscreen view
                                            selectedImage = image
                                            isImageFullScreen.toggle()
                                        }
                                }
                            }
                        }
                        
                    }
                }
                
                Map {
                    Marker(entry.title, coordinate: entry.location.coordinate)
                }
                .frame(height: 250)
                .cornerRadius(10)
                
                Button(role: .destructive) {
                    viewModel.deleteEntry(entry: entry)
                    dismiss()
                } label: {
                    Text("Delete entry")
                        .frame(maxWidth: .infinity)
                        .frame(height: 36)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if isEditing {
                        viewModel.updateEntry(entry: entry, newTitle: newTitle, newDescription: newDescription)
                    }
                    isEditing.toggle()
                } label: {
                    Text("Edit")
                }
            }
        }
        .overlay(
            Group {
                if isImageFullScreen, let selectedImage = selectedImage {
                    Color.black.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isImageFullScreen = false // Dismiss fullscreen on tap
                        }
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(8)
                        .shadow(radius: 10)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: isImageFullScreen)
        )
    }
}

// Helper to format the date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()
