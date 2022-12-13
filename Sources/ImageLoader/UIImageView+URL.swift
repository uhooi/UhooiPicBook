//
//  UIImageView+URL.swift
//
//
//  Created by uhooi on 2022/01/14.
//

import Foundation
import class UIKit.UIImage
import class UIKit.UIImageView

@MainActor
public extension UIImageView {
    func loadImage(with url: URL) async {
        image = await UIImage.create(with: url)
    }

    func loadGIFImage(with url: URL) {
        image = UIImage.createGIF(with: url)
    }
}
