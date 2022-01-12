//
//  MonsterCollectionSection.swift
//
//
//  Created by uhooi on 2022/01/11.
//

import UIKit

@MainActor
final class MonsterCollectionSection {
    private let presenter: MonsterSectionEventHandler

    private var monsters: [MonsterEntity] = []

    init(presenter: MonsterSectionEventHandler) {
        self.presenter = presenter
    }

    func setMonsters(_ monsters: [MonsterEntity]) {
        self.monsters = monsters
    }
}

extension MonsterCollectionSection: CollectionSectionProtocol {
    func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(116.0)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0)
        section.interGroupSpacing = 12.0
        return section
    }

    func didSelectItemAt(_ row: Int) {
        Task {
            let monster = monsters[row]
            await presenter.didSelectMonster(monster: monster)
        }
    }
}
