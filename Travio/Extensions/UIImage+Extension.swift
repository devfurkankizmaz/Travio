//
//  UIImage+Extension.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

extension UIImage {
    enum ImageFormat {
        case jpeg(compressionQuality: CGFloat)
        case png
    }

    func convertToData(withFormat format: ImageFormat) -> Data? {
        switch format {
        case .jpeg(let compressionQuality):
            return self.jpegData(compressionQuality: compressionQuality)
        case .png:
            return self.pngData()
        }
    }
}
