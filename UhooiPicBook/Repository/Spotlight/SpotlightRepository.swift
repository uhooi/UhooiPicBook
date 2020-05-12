//
//  SpotlightRepository.swift
//  UhooiPicBook
//
//  Created by Tomosuke Okada on 2020/05/11.
//

import CoreSpotlight
import Foundation
import MobileCoreServices

/// @mockable
protocol SpotlightRepository: AnyObject {
    func save(_ monster: MonsterEntity)
}

final class SpotlightClient {

    private let searchableIndex = CSSearchableIndex.default()
    private let imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager()
    private let userDefaults = UserDefaults.standard
}

extension SpotlightClient: SpotlightRepository {

    func save(_ monster: MonsterEntity) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(monster) else {
            return
        }

        self.imageCacheManager.cacheImage(imageUrl: monster.iconUrl) { result in
            switch result {
            case .success(let image):
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
                attributeSet.title = monster.name
                attributeSet.contentDescription = monster.description
                attributeSet.thumbnailData = image.pngData()

                let userDefaultsKey = "Spotlight_\(monster.name)"

                let item = CSSearchableItem(
                    uniqueIdentifier: userDefaultsKey,
                    domainIdentifier: "UhooiPicBook",
                    attributeSet: attributeSet
                )
                self.searchableIndex.indexSearchableItems([item], completionHandler: nil)
                self.userDefaults.set(data, forKey: userDefaultsKey)
            case .failure:
                // No need for error handling, as there is no need to give the user feedback on save failures for Spotlight search.
                break
            }
        }
    }
}
