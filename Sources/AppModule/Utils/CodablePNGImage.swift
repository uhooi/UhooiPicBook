//
//  CodablePNGImage.swift
//
//
//  Created by uhooi on 2022/01/12.
//

import UIKit.UIImage

struct CodablePNGImage {
    var pngData: Data

    init(uiImage: UIImage) {
        guard let pngData = uiImage.pngData() else {
            fatalError("Fail to initialize CodablePNGImage.")
        }
        self.pngData = pngData
    }

    func uiImage() -> UIImage {
        guard let image = UIImage(data: pngData) else {
            fatalError("Fail to load image.")
        }
        return image
    }
}

extension CodablePNGImage: Codable {}
