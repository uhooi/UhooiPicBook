//
//  CodableImage.swift
//
//
//  Created by uhooi on 2022/01/12.
//

import UIKit.UIImage

struct CodableImage {
    var pngData: Data = .init()

    init(uiImage: UIImage) {
        uiImage.pngData()
    }

    func uiImage() -> UIImage {
        guard let image = UIImage(data: pngData) else {
            fatalError("Fail to load image.")
        }
        return image
    }
}

extension CodableImage: Codable {}
