//
//  ContentView.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 27/06/23.
//

import SwiftUI

struct ContentView: View {
    @Binding var isLoading: Bool;
    @Binding var loadingProgress: String?
    
    // Variables de la vista para el manejo de la selección del video
    @State private var showVideoPicker = false
    @State private var videoURL: URL?
    
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
                                isLoading: $isLoading,
                                loadingProgress: $loadingProgress
                            )
                        }
                    }
                }
            }
            .navigationTitle("compressVideo")
        }
    }
}

#Preview {
    ContentView(
        isLoading: .constant(false),
        loadingProgress: .constant("")
    )
}
