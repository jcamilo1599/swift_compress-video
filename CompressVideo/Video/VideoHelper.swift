//
//  VideoHelper.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 28/06/23.
//

import SwiftUI
import PhotosUI
import Foundation
import LightCompressor

class VideosHelper {
    /// Obtiene la ruta y nombre para el video
    static func getPath(type: String) -> String {
        return ProcessInfo.processInfo.globallyUniqueString + "." + type
    }
    
    /// Obtiene el directorio temporal para el video
    static func temporaryPath(type: String) -> URL {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        return temporaryDirectoryURL.appendingPathComponent(getPath(type: type))
    }
    
    /// Comprime y guarda el video
    static func compressAndSave(url: URL, progress: @escaping (String?) -> Void, completion: @escaping (URL?) -> Void) {
        let temporaryFile = VideosHelper.temporaryPath(type: "mp4")
        let videoCompressor = LightCompressor()
        
        _ = videoCompressor.compressVideo(
            videos: [
                .init(
                    source: url,
                    destination: temporaryFile,
                    configuration: .init(isMinBitrateCheckEnabled: false)
                )
            ],
            progressQueue: .main,
            progressHandler: { currentProgress in
                let value = "\(String(format: "%.0f", currentProgress.fractionCompleted * 100))%"
                progress(value)
            },
            completion: { result in
                switch result {
                case .onStart:
                    break;
                case .onSuccess(_, let path):
                    completion(path)
                    break;
                default:
                    completion(nil)
                    break;
                }
            }
        )
    }
    
    /// Crea una lista de imágenes a partir de un video
    static func toImageList(from url: URL, interval: Double, maxImages: Int, completion: @escaping ([UIImage]) -> Void) {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        var images: [UIImage] = []
        
        // Configurar propiedades del generador de imágenes
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        
        // Determina si conservar o no las preferencias de transformación
        imageGenerator.appliesPreferredTrackTransform = true
        
        let duration = CMTimeGetSeconds(asset.duration)
        var currentTime = CMTime.zero
        
        DispatchQueue.global(qos: .userInitiated).async {
            var loadedImages = 0
            
            // Generar imágenes del video en intervalos regulares
            while currentTime.seconds < duration && loadedImages < maxImages {
                do {
                    let imageRef = try imageGenerator.copyCGImage(at: currentTime, actualTime: nil)
                    let image = UIImage(cgImage: imageRef)
                    
                    if let thumbnailImage = ImagesHelper.resize(image: image, maxSize: 1000) {
                        images.append(thumbnailImage)
                    } else {
                        images.append(image)
                    }
                    
                    loadedImages += 1
                } catch {
                    completion(images)
                    return
                }
                
                currentTime = CMTimeAdd(currentTime, CMTime(seconds: interval, preferredTimescale: 600))
            }
            
            completion(images)
        }
    }
}
