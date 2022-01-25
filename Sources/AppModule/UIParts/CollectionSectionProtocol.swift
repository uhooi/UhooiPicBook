//
//  CollectionSectionProtocol.swift
//
//
//  Created by uhooi on 2022/01/11.
//

import UIKit

@MainActor
protocol CollectionSectionProtocol {
    func layoutSection() -> NSCollectionLayoutSection
    func didSelectItem(at row: Int)
}
