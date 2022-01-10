//
//  InAppWebBrowserRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 27/02/2021.
//  Copyright © 2021 THE Uhooi. All rights reserved.
//

import UIKit

@MainActor
enum InAppWebBrowserRouter {

    // MARK: Type Methods

    static func show(_ parent: UIViewController, url: URL) {
        let vc = assembleModule(url: url)
        parent.present(vc, animated: true)
    }

    // MARK: Other Private Methods

    private static func assembleModule(url: URL) -> InAppWebBrowserViewController {
        let view = R.Storyboard.InAppWebBrowser.instantiateInitialViewController()
        view.url = url

        return view
    }

}
