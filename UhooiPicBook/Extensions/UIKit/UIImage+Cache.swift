//
//  UIImage+Cache.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/03.
//

import UIKit

extension UIImage {

    static let imageCache = NSCache<AnyObject, AnyObject>()

    static func cacheImage(imageUrl: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let imageFromCache = UIImage.imageCache.object(forKey: imageUrl as AnyObject) as? UIImage {
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
                    fatalError() // TODO: エラーハンドリング
                }

                imageToCache = image
                UIImage.imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)
            }

            group.leave()
        }.resume()

        group.notify(queue: .global()) {
            completion(someError.map(Result.failure) ?? .success(imageToCache))
        }
    }

}
