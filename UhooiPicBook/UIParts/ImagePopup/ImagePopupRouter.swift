//
//  ImagePopupRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/15.
//

import UIKit

final class ImagePopupRouter {

    // MARK: Stored Instance Properties

    private unowned let viewController: ImagePopupViewController

    // MARK: Initializers

    private init(viewController: ImagePopupViewController) {
        self.viewController = viewController
    }

    // MARK: Type Methods

    static func show(_ parent: UIViewController, image: UIImage) {
        let vc = assembleModule(image: image)
        parent.present(vc, animated: false)
    }

    // MARK: Other Private Methods

    private static func assembleModule(image: UIImage) -> ImagePopupViewController {
        guard let view = R.storyboard.imagePopup.instantiateInitialViewController() else {
            fatalError("Fail to load ImagePopupViewController from Storyboard.")
        }
        view.image = image

        return view
    }

}
