//
//  MonsterCollectionSection.swift
//
//
//  Created by uhooi on 2022/01/11.
//

import UIKit

@MainActor
final class MonsterCollectionSection<Presenter: MonsterSectionEventHandler> {
    private unowned let presenter: Presenter

    init(presenter: Presenter) {
        self.presenter = presenter
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

    func didSelectItem(at row: Int) {
        Task {
            await presenter.didSelectMonster(at: row)
        }
    }
}
