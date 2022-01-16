//
//  UIImageView+URL.swift
//
//
//  Created by uhooi on 2022/01/14.
//

import UIKit.UIImageView

@MainActor
public extension UIImageView {
    func loadImage(with url: URL) async {
        image = await UIImage.create(url: url)
    }

    func loadGIFImage(with url: URL) {
        image = UIImage.createGIF(url: url)
    }
}
