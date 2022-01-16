//
//  ImageCacheManager.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/03.
//

import UIKit.UIImage

final class ImageCacheManager {
    static let imageCache = NSCache<AnyObject, AnyObject>()

    func cacheImage(with url: URL) async throws -> UIImage {
        if let imageFromCache = ImageCacheManager.imageCache.object(forKey: url as AnyObject) as? UIImage {
            return imageFromCache
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageCacheError.loadingFailure
        }
        ImageCacheManager.imageCache.setObject(image, forKey: url as AnyObject)
        return image
    }

    func cacheGIFImage(with url: URL) -> UIImage? {
        if let imageFromCache = ImageCacheManager.imageCache.object(forKey: url as AnyObject) as? UIImage {
            return imageFromCache
        }

        guard let imageToCache = UIImage.gifImage(with: url) else {
            return nil
        }

        ImageCacheManager.imageCache.setObject(imageToCache, forKey: url as AnyObject)

        return imageToCache
    }
}
