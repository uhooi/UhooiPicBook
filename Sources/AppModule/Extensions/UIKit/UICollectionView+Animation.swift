//
//  UICollectionView+Animation.swift
//  UhooiPicBook
//
//  Created by Tomosuke Okada on 2021/02/22.
//

import UIKit

extension UICollectionView {
    func executeCellSlideUpAnimation() {
        // If not called first, `visibleCells` will be empty.
        layoutIfNeeded()

        // Temporarily bring visible cells under the collection view.
        visibleCells.forEach {
            $0.transform = CGAffineTransform(
                translationX: 0,
                y: bounds.size.height
            )
        }

        // Animate it back to where it should be.
        visibleCells.enumerated().forEach { object in
            UIView.animate(
                withDuration: 0.6,
                delay: 0.04 * Double(object.offset),
                usingSpringWithDamping: 1.6,
                initialSpringVelocity: 0,
                options: UIView.AnimationOptions.curveEaseIn,
                animations: {
                    object.element.transform = CGAffineTransform(translationX: 0, y: 0)
                },
                completion: nil
            )
        }
    }
}
