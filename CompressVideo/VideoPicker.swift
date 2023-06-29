//
//  VideoPicker.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 29/06/23.
//

import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: URL?
    @Binding var isLoading: Bool
    @Binding var loadingProgress: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<VideoPicker>) -> UIViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .videos

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<VideoPicker>) {
    }

    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else {
                return
            }

            DispatchQueue.main.async {
                self.parent.isLoading = true
                self.parent.loadingProgress = nil
            }

            DispatchQueue.global(qos: .userInitiated).async {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                    if let url = url {
                        DispatchQueue.main.async {
                            self.parent.loadingProgress = "0%"
                        }

                        // Comprime y guarda el video
                        VideosHelper.compressAndSave(url: url, progress: self.parent.progressSave, completion: self.parent.completionSave)
                    } else {
                        DispatchQueue.main.async {
                            self.parent.isLoading = false
                        }
                    }
                }
            }
        }
    }

    private func progressSave(currentProgress: String?) {
        DispatchQueue.main.async {
            loadingProgress = currentProgress
        }
    }

    private func completionSave(url: URL?) {
        DispatchQueue.main.async {
            if url != nil {
                videoURL = url
            }

            isLoading = false
            loadingProgress = nil
        }
    }
}
