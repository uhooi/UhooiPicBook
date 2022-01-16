//
//  UIImage+URL.swift
//
//
//  Created by uhooi on 2022/01/16.
//

import UIKit.UIImage

@MainActor
extension UIImage {
    public static func create(url: URL) async -> UIImage? {
        try? await ImageCacheManager().cacheImage(with: url)
    }

    static func createGIF(url: URL) -> UIImage? {
        ImageCacheManager().cacheGIFImage(with: url)
    }
}
