//
//  ImageCacheManager.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/03.
//

import UIKit

/// @mockable
protocol ImageCacheManagerProtocol: AnyObject {
    func cacheImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cacheGIFImage(imageUrl: URL) -> UIImage?
}

final class ImageCacheManager: ImageCacheManagerProtocol {

    static let imageCache = NSCache<AnyObject, AnyObject>()

    func cacheImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let imageFromCache = ImageCacheManager.imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
            completion(.success(imageFromCache))
            return
        }

        var imageToCache = UIImage()
        var someError: Error?

        let group = DispatchGroup()
        group.enter()

        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let error = error {
                someError = error
            } else {
                guard let data = data, let image = UIImage(data: data) else {
                    fatalError("Fail to load image.") // TODO: エラーハンドリング
                }

                imageToCache = image
                ImageCacheManager.imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)
            }

            group.leave()
        }.resume()

        group.notify(queue: .global()) {
            completion(someError.map(Result.failure) ?? .success(imageToCache))
        }
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
