//
//  ImagesHelper.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 7/07/23.
//

import Foundation
import UIKit
import ImageIO

struct ImagesHelper {
    /// Reduce el tamaño y al mismo tiempo el peso de una imagen
    static func resize(image: UIImage, maxSize: CGFloat) -> UIImage? {
        let originalWidth = image.size.width
        let originalHeight = image.size.height
        
        // Calcular la relación de aspecto
        let aspectRatio = originalWidth / originalHeight
        
        // Calcular las nuevas dimensiones manteniendo la relación de aspecto
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        if originalWidth > originalHeight {
            newWidth = maxSize
            newHeight = maxSize / aspectRatio
        } else {
            newHeight = maxSize
            newWidth = maxSize * aspectRatio
        }
        
        // Crear un nuevo rectángulo con las nuevas dimensiones
        let newSize = CGSize(width: newWidth, height: newHeight)
        let newRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        // Dibujar la imagen original en el nuevo rectángulo
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: newRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
