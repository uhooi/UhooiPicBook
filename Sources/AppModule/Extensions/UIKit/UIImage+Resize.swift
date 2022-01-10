//
//  UIImage+Resize.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/09/17.
//

import UIKit

extension UIImage {
    func resize(_ afterSize: CGSize) -> UIImage? {
        let widthRatio = afterSize.width / size.width
        let heightRatio = afterSize.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
