//
//  ImageCacheManager.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/03.
//

import UIKit

/// @mockable
public protocol ImageCacheManagerProtocol: AnyObject {
    func cacheImage(imageUrl: URL) async throws -> UIImage
    func cacheGIFImage(imageUrl: URL) -> UIImage?
}

public final class ImageCacheManager {
    public static let imageCache = NSCache<AnyObject, AnyObject>()

    public init() {}
}

extension ImageCacheManager: ImageCacheManagerProtocol {
    public func cacheImage(imageUrl: URL) async throws -> UIImage {
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

    public func cacheGIFImage(imageUrl: URL) -> UIImage? {
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
