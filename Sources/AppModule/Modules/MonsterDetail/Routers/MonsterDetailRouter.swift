//
//  MonsterDetailRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit
import ImageCache

/// @mockable
@MainActor
protocol MonsterDetailRouterInput: AnyObject {
    func popupDancingImage(_ dancingImage: UIImage)
    func showActivity(_ senderView: UIView, text: String, icon: UIImage)
}

@MainActor
public final class MonsterDetailRouter {

    // MARK: Stored Instance Properties

    private unowned let viewController: MonsterDetailViewController

    // MARK: Initializers

    private init(viewController: MonsterDetailViewController) {
        self.viewController = viewController
    }

    // MARK: Type Methods

    public static func assembleModule(monster: MonsterEntity) -> MonsterDetailViewController {
        let view = R.Storyboard.MonsterDetail.instantiateInitialViewController()
        let interactor = MonsterDetailInteractor()
        let router = MonsterDetailRouter(viewController: view)
        let presenter = MonsterDetailPresenter(view: view, interactor: interactor, router: router)

        view.inject(
            presenter: presenter,
            imageCacheManager: ImageCacheManager(),
            monster: monster
        )
        interactor.presenter = presenter

        return view
    }
}

extension MonsterDetailRouter: MonsterDetailRouterInput {
    func popupDancingImage(_ dancingImage: UIImage) {
        ImagePopupRouter.show(viewController, image: dancingImage)
    }

    func showActivity(_ senderView: UIView, text: String, icon: UIImage) {
        ActivityRouter.show(viewController, sourceView: senderView, text: text, url: nil, image: icon)
    }
}
