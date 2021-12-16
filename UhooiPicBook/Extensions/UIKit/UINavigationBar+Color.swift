//
//  UINavigationBar+Color.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/08/28.
//

import UIKit

extension UINavigationBar {
    func configureBackgroundColor(_ color: UIColor?) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
    }
}
