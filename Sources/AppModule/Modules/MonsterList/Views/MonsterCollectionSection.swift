//
//  MonsterCollectionSection.swift
//
//
//  Created by uhooi on 2022/01/11.
//

import UIKit
import ImageCache
import Logger

@MainActor
final class MonsterCollectionSection {
    private let presenter: MonsterListEventHandler
    private let imageCacheManager: ImageCacheManagerProtocol
    private let logger: LoggerProtocol

    private var monsters: [MonsterEntity] = []

    init(
        presenter: MonsterListEventHandler,
        imageCacheManager: ImageCacheManagerProtocol,
        logger: LoggerProtocol = Logger.default
    ) {
        self.presenter = presenter
        self.imageCacheManager = imageCacheManager
        self.logger = logger
    }

    func setMonsters(_ monsters: [MonsterEntity]) {
        self.monsters = monsters
    }
}

extension MonsterCollectionSection: CollectionSectionProtocol {
    var numberOfItems: Int { monsters.count }

    func layoutSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        ))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(128.0)
        ), subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 6.0, leading: 16.0, bottom: 6.0, trailing: 16.0)
        return NSCollectionLayoutSection(group: group)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MonsterCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? MonsterCollectionViewCell else {
            fatalError("Fail to load MonsterCollectionViewCell.")
        }

        Task {
            do {
                let monster = monsters[indexPath.row]
                let icon = try await imageCacheManager.cacheImage(imageUrl: monster.iconUrl)
                cell.setup(name: monster.name, icon: icon, elevation: 1.0)
            } catch {
                // TODO: エラーハンドリング
                logger.exception(error, file: #file, function: #function, line: #line, column: #column)
            }
        }

        return cell
    }

    func didSelectItemAt(_ row: Int) {
        Task {
            let monster = monsters[row]
            await presenter.didSelectMonster(monster: monster)
        }
    }
}
