//
//  ActivityRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/05/29.
//

import UIKit

@MainActor
enum ActivityRouter {

    // MARK: Type Methods

    static func show(_ parent: UIViewController, sourceView: UIView?, text: String?, url: URL?, image: UIImage?) {
        if text == nil && url == nil && image == nil {
            return // TODO: エラーハンドリング
        }
        let activityItems: [Any?] = [text, url, image]
        let activityVC = UIActivityViewController(activityItems: activityItems as [Any], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sourceView
        parent.present(activityVC, animated: true)
    }

}
