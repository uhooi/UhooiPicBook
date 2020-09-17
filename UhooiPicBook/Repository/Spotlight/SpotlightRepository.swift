//
//  SpotlightRepository.swift
//  UhooiPicBook
//
//  Created by Tomosuke Okada on 2020/05/11.
//

import CoreSpotlight
import MobileCoreServices
import UIKit

/// @mockable
protocol SpotlightRepository: AnyObject { // swiftlint:disable:this file_types_order
    func saveMonster(_ monster: MonsterEntity, forKey key: String)
}

final class SpotlightClient {

    // MARK: Stored Instance Properties

    private let searchableIndex = CSSearchableIndex.default()
    private let imageCacheManager: ImageCacheManagerProtocol

    // MARK: Initializer

    init(imageCacheManager: ImageCacheManagerProtocol) {
        self.imageCacheManager = imageCacheManager
    }

}

extension SpotlightClient: SpotlightRepository {

    func saveMonster(_ monster: MonsterEntity, forKey key: String) {
        self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl) { result in
            switch result {
            case .success(let image):
                let thumbnailData = image.resize(CGSize(width: 180.0, height: 180.0))?.pngData()
                let item = CSSearchableItem(
                    uniqueIdentifier: key,
                    domainIdentifier: Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
                    attributeSet: self.createAttributeSet(title: monster.name, contentDescription: monster.description, thumbnailData: thumbnailData)
                )
                self.searchableIndex.indexSearchableItems([item], completionHandler: nil)
            case .failure:
                // No need for error handling, as there is no need to give the user feedback on save failures for Spotlight search.
                break
            }
        }
    }

    private func createAttributeSet(title: String, contentDescription: String, thumbnailData: Data?) -> CSSearchableItemAttributeSet {
        let attributeSet: CSSearchableItemAttributeSet
        if #available(iOS 14.0, *) {
            attributeSet = .init(contentType: .data)
        } else {
            attributeSet = .init(itemContentType: kUTTypeData as String)
        }
        attributeSet.title = title
        attributeSet.contentDescription = contentDescription
        attributeSet.thumbnailData = thumbnailData
        return attributeSet
    }

}
