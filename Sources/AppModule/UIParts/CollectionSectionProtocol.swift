//
//  CollectionSectionProtocol.swift
//
//
//  Created by uhooi on 2022/01/11.
//

import UIKit

@MainActor
protocol CollectionSectionProtocol {
    var numberOfItems: Int { get }
    func layoutSection(in collectionView: UICollectionView) -> NSCollectionLayoutSection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func didSelectItemAt(_ row: Int)
}
