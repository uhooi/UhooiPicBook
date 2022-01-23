//
//  SpotlightRepository.swift
//  UhooiPicBook
//
//  Created by Tomosuke Okada on 2020/05/11.
//

import UIKit.UIImage
import CoreGraphics.CGGeometry
import CoreSpotlight
import ImageLoader
import Logger

/// @mockable
protocol SpotlightRepository: AnyObject { // swiftlint:disable:this file_types_order
    func saveMonster(_ monster: MonsterEntity, forKey key: String) async
}

final class SpotlightClient {

    // MARK: Stored Instance Properties

    private let searchableIndex = CSSearchableIndex.default()
    private let logger: LoggerProtocol

    // MARK: Initializer

    init(logger: LoggerProtocol = Logger.default) {
        self.logger = logger
    }
}

extension SpotlightClient: SpotlightRepository {
    func saveMonster(_ monster: MonsterEntity, forKey key: String) async {
        guard let icon = await UIImage.create(with: monster.iconURL) else {
            return
        }
        let thumbnailData = icon.resize(CGSize(width: 180.0, height: 180.0))?.pngData()
        let item = CSSearchableItem(
            uniqueIdentifier: key,
            domainIdentifier: Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
            attributeSet: createAttributeSet(
                title: monster.name,
                contentDescription: monster.description,
                thumbnailData: thumbnailData
            )
        )
        do {
            try await searchableIndex.indexSearchableItems([item])
        } catch {
            // No need for error handling, as there is no need to give the user feedback on save failures for Spotlight search.
            logger.exception(error, file: #file, function: #function, line: #line, column: #column)
            return
        }
    }

    // MARK: Other Private Methods

    private func createAttributeSet(title: String, contentDescription: String, thumbnailData: Data?) -> CSSearchableItemAttributeSet {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .data)
        attributeSet.title = title
        attributeSet.contentDescription = contentDescription
        attributeSet.thumbnailData = thumbnailData
        return attributeSet
    }
}
