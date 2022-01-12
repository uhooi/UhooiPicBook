//
//  MonsterConverter.swift
//
//
//  Created by uhooi on 2022/01/13.
//

import UIKit.UIColor
import ImageCache

public final class MonsterConverter {

    // MARK: Stored Instance Properties

    private let imageCacheManager: ImageCacheManagerProtocol

    // MARK: Initializers

    public init(imageCacheManager: ImageCacheManagerProtocol) {
        self.imageCacheManager = imageCacheManager
    }

    // MARK: Other Public Methods

    public func convertEntityToItem(entity: MonsterEntity) async -> MonsterItem {
        guard let icon = try? await imageCacheManager.cacheImage(imageUrl: entity.iconUrl)
        else {
            fatalError("Fail to load icon.")
        }
        guard let dancingImage = imageCacheManager.cacheGIFImage(imageUrl: entity.dancingUrl)
        else {
            fatalError("Fail to load dancing image.")
        }

        return MonsterItem(
            name: entity.name,
            description: entity.description,
            baseColor: UIColor(hex: entity.baseColorCode),
            icon: icon,
            dancingImage: dancingImage
        )
    }
}
