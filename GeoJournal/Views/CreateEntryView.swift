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
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoDataArray: [Data] = []
    @State private var showingCamera = false
    @State private var capturedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add Photos")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            PhotosPicker(
                                selection: $selectedPhotos,
                                maxSelectionCount: 10,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                HStack {
                                    Image(systemName: "photo")
                                    Text("Select Photos")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                            }
                            .onChange(of: selectedPhotos) { newItems in
                                photoDataArray = [] // Reset before adding new photos
                                Task {
                                    for item in newItems {
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            photoDataArray.append(data)
                                        }
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
                    
                    if !photoDataArray.isEmpty || capturedImage != nil {
                        VStack(alignment: .leading) {
                            Text("Image Previews")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                                if let capturedImage {
                                    Image(uiImage: capturedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                                
                                ForEach(photoDataArray, id: \.self) { data in
                                    if let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                    }
                                }
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
                        var allPhotos = photoDataArray
                        if let capturedImageData = capturedImage?.jpegData(compressionQuality: 0.8) {
                            allPhotos.append(capturedImageData)
                        }
                        viewModel.createNewEntry(
                            title: entryTitle,
                            description: entryDescription,
                            photos: allPhotos
                        )
                        entryTitle = ""
                        entryDescription = ""
                        capturedImage = nil
                        photoDataArray = []
                        selectedPhotos = []
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
//    private func previewImage() -> UIImage? {
//        if let capturedImage {
//            return capturedImage
//        } else if let photoData, let image = UIImage(data: photoData) {
//            return image
//        }
//        return nil
//    }
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
