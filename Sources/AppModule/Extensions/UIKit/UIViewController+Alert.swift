//
//  UIViewController+Alert.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/02/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
