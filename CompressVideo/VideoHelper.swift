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
    /// Obtiene el directorio temporal para el video
    static func temporaryPath(type: String) -> URL {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let temporaryFilename = ProcessInfo.processInfo.globallyUniqueString + "." + type
        
        return temporaryDirectoryURL.appendingPathComponent(temporaryFilename)
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
}
