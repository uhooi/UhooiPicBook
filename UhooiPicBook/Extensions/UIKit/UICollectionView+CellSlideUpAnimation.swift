//
//  UICollectionView+CellSlideUpAnimation.swift
//  UhooiPicBook
//
//  Created by Tomosuke Okada on 2021/02/22.
//

import UIKit

extension UICollectionView {

    func executeCellSlideUpAnimation() {
        // 先に呼んでないとvisibleCellsが空になる
        self.layoutIfNeeded()

        // 一旦CollectionViewの下に持っていく
        self.visibleCells.forEach {
            $0.transform = CGAffineTransform(
                translationX: 0,
                y: self.bounds.size.height
            )
        }
        
        // あるべき位置にアニメーションで戻す
        self.visibleCells.enumerated().forEach { object in
            UIView.animate(
                withDuration: 0.6,
                delay: 0.04 * Double(object.offset),
                usingSpringWithDamping: 1.6,
                initialSpringVelocity: 0,
                options: UIView.AnimationOptions.curveEaseIn,
                animations: {
                    object.element.transform = CGAffineTransform(translationX: 0, y: 0)
                },
                completion: nil)
        }
    }
}
