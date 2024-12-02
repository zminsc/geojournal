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
    @State private var showDeleteConfirmation = false
    @State private var selectedPhotoIndex: Int? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
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
                            .onChange(of: selectedPhotos) { _, newItems in
                                photoDataArray = []
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
                                    .onTapGesture {
                                        // Trigger delete for the captured image
                                        selectedPhotoIndex = -1 // Special value for capturedImage
                                        showDeleteConfirmation = true
                                    }
                            }
                            
                            ForEach(photoDataArray.indices, id: \.self) { index in
                                if let uiImage = UIImage(data: photoDataArray[index]) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .onTapGesture {
                                            selectedPhotoIndex = index
                                            showDeleteConfirmation = true
                                        }
                                        .transition(.scale)
                                }
                            }
                            
                            Text("Tap Image to Delete")
                                .foregroundColor(.red)
                        }
                        .animation(.easeInOut(duration: 0.3), value: photoDataArray)
                        .animation(.easeInOut(duration: 0.3), value: capturedImage)
                        .confirmationDialog("Are you sure you want to delete this photo?", isPresented: $showDeleteConfirmation) {
                            Button("Delete", role: .destructive) {
                
                                withAnimation {
                                    deletePhoto()
                                }
                            
                            }
                            Button("Cancel", role: .cancel) {}
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
    private func deletePhoto() {
        if let index = selectedPhotoIndex {
            if index == -1 {
                capturedImage = nil
            } else {
                photoDataArray.remove(at: index)
                selectedPhotos.remove(at: index)
            }
        }
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
