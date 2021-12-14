//
//  SpotlightRepository.swift
//  UhooiPicBook
//
//  Created by Tomosuke Okada on 2020/05/11.
//

import CoreGraphics.CGGeometry
import CoreSpotlight

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
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let icon = try await self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl)
                let thumbnailData = icon.resize(CGSize(width: 180.0, height: 180.0))?.pngData()
                let item = CSSearchableItem(
                    uniqueIdentifier: key,
                    domainIdentifier: Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
                    attributeSet: self.createAttributeSet(
                        title: monster.name,
                        contentDescription: monster.description,
                        thumbnailData: thumbnailData
                    )
                )
                self.searchableIndex.indexSearchableItems([item], completionHandler: nil)
            } catch {
                // No need for error handling, as there is no need to give the user feedback on save failures for Spotlight search.
                print(error)
                return
            }
        }
    }

    private func createAttributeSet(title: String, contentDescription: String, thumbnailData: Data?) -> CSSearchableItemAttributeSet {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .data)
        attributeSet.title = title
        attributeSet.contentDescription = contentDescription
        attributeSet.thumbnailData = thumbnailData
        return attributeSet
    }

}
