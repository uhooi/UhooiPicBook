//
//  UINavigationBar+Color.swift
//  UINavigationBar+Color
//
//  Created by uhooi on 2021/08/28.
//

import UIKit

extension UINavigationBar {
    func configureBackgroundColor(_ color: UIColor?) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
    }
}
