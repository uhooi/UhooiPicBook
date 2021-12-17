//
//  ImageCacheManager.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/03.
//

import UIKit

enum ImageCacheError: Error {
    case loadingFailure
}

/// @mockable
protocol ImageCacheManagerProtocol: AnyObject {
    func cacheImage(imageUrl: URL) async throws -> UIImage
    func cacheGIFImage(imageUrl: URL) -> UIImage?
}

final class ImageCacheManager: ImageCacheManagerProtocol {

    static let imageCache = NSCache<AnyObject, AnyObject>()

    func cacheImage(imageUrl: URL) async throws -> UIImage {
        if let imageFromCache = ImageCacheManager.imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            return imageFromCache
        }

        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        guard let image = UIImage(data: data) else {
            throw ImageCacheError.loadingFailure
        }
        ImageCacheManager.imageCache.setObject(image, forKey: imageUrl as AnyObject)
        return image
    }

    func cacheGIFImage(imageUrl: URL) -> UIImage? {
        if let imageFromCache = ImageCacheManager.imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            return imageFromCache
        }

        guard let imageToCache = UIImage.gifImage(with: imageUrl) else {
            return nil
        }

        ImageCacheManager.imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)

        return imageToCache
    }

}
