//
//  HomeView.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 7/07/23.
//

import SwiftUI
import Photos

struct HomeView: View {
    @Binding var isLoading: Bool;
    @Binding var loadingProgress: String?
    
    @Binding var showAlert: Bool
    @Binding var alertTitle: String
    @Binding var alertDescription: String
    
    // Variables de la vista para el manejo de la selección del video
    @State private var showVideoPicker = false
    @State private var videoURL: URL?
    @State private var videoThumbnails: [UIImage] = []
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("select")) {
                    Text("selectText")
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            showVideoPicker = true
                            videoURL = nil
                            videoThumbnails = []
                        }) {
                            Text("select")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showVideoPicker) {
                            VideoPicker(
                                videoURL: $videoURL,
                                videoThumbnails: $videoThumbnails,
                                isLoading: $isLoading,
                                loadingProgress: $loadingProgress
                            )
                        }
                    }
                }
                
                if videoThumbnails.count > 0 {
                    Section(header: Text("thumbnails")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(videoThumbnails, id: \.self) { thumbnail in
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: 250, maxHeight: 250)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                
                if videoURL != nil {
                    Section(header: Text("save")) {
                        HStack {
                            Spacer()
                            Button(action: saveVideo) {
                                Text("save")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("compressVideo")
        }
    }
    
    private func saveVideo() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL!)
        }) { success, error in
            if success {
                alertTitle = "okTitle"
                alertDescription = "okDescription"
                
                // Limpia las variables donde se guardo información del video
                videoURL = nil
                videoThumbnails = []
            } else if error != nil {
                alertTitle = "errorTitle"
                alertDescription = "errorDescription"
            }
            
            showAlert = true
        }
    }
}

#Preview {
    HomeView(
        isLoading: .constant(false),
        loadingProgress: .constant(""),
        showAlert: .constant(false),
        alertTitle: .constant(""),
        alertDescription: .constant("")
    )
}
