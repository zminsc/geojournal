//
//  CreatePostView.swift
//  GeoJournal
//
//  Created by Steven Chang on 12/1/24.
//

import SwiftUI
import PhotosUI

struct CreateEntryView: View {
    @EnvironmentObject var viewModel: EntryViewModel
    
    @State private var entryTitle = ""
    @State private var entryDescription = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var showingCamera = false
    @State private var capturedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add Photo")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            PhotosPicker(
                                selection: $selectedPhoto,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text("Select Photo")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                            }
                            .onChange(of: selectedPhoto) { _, newValue in
                                Task {
                                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                        photoData = data
                                        capturedImage = nil
                                    }
                                }
                            }
                            
                            Button {
                                showingCamera = true
                            } label: {
                                HStack {
                                    Image(systemName: "camera")
                                    Text("Take Photo")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.gray)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .sheet(isPresented: $showingCamera) {
                        ImagePicker(image: $capturedImage)
                    }
                    
                    if let previewImage = previewImage() {
                        VStack(alignment: .leading) {
                            Text("Image Preview")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(uiImage: previewImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 200)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                
                                Spacer()
                                
                                Button("Remove Image") {
                                    capturedImage = nil
                                    photoData = nil
                                    selectedPhoto = nil
                                }
                                .padding(.horizontal)
                                .foregroundColor(.red)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("New Entry Details")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Title", text: $entryTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Description", text: $entryDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button(action: {
                        viewModel.createNewEntry(
                            title: entryTitle,
                            description: entryDescription
                        )
                        entryTitle = ""
                        entryDescription = ""
                    }) {
                        Text("Save Entry")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Create Entry")
        }
    }
    
    // Helper to get the preview image
    private func previewImage() -> UIImage? {
        if let capturedImage {
            return capturedImage
        } else if let photoData, let image = UIImage(data: photoData) {
            return image
        }
        return nil
    }
}

// ImagePicker struct remains the same

// MARK: - ImagePicker for Camera (from chat, need to read through)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
