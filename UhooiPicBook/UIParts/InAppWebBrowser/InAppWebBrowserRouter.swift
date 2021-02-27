//
//  InAppWebBrowserRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 27/02/2021.
//  Copyright © 2021 THE Uhooi. All rights reserved.
//

import UIKit

enum InAppWebBrowserRouter {

    // MARK: Type Methods

    static func show(_ parent: UIViewController, url: URL) {
        let vc = assembleModule(url: url)
        parent.present(vc, animated: true)
    }

    // MARK: Other Private Methods

    private static func assembleModule(url: URL) -> InAppWebBrowserViewController {
        guard let view = R.storyboard.inAppWebBrowser.instantiateInitialViewController() else {
            fatalError("Fail to load InAppWebBrowserViewController from Storyboard.")
        }
        view.url = url

        return view
    }

}
