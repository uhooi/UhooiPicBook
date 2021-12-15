//
//  MonsterDetailRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 04/03/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
protocol MonsterDetailRouterInput: AnyObject {
    func popupDancingImage(_ dancingImage: UIImage)
    func showActivity(_ senderView: UIView, text: String, icon: UIImage)
}

final class MonsterDetailRouter {

    // MARK: Stored Instance Properties

    private unowned let viewController: MonsterDetailViewController

    // MARK: Initializers

    private init(viewController: MonsterDetailViewController) {
        self.viewController = viewController
    }

    // MARK: Type Methods

    static func assembleModule(monster: MonsterEntity) -> MonsterDetailViewController {
        guard let view = R.storyboard.monsterDetail.instantiateInitialViewController() else {
            fatalError("Fail to load MonsterDetailViewController from Storyboard.")
        }
        let interactor = MonsterDetailInteractor()
        let router = MonsterDetailRouter(viewController: view)
        let presenter = MonsterDetailPresenter(view: view, interactor: interactor, router: router)

        Task { @MainActor in
            view.inject(
                presenter: presenter,
                imageCacheManager: ImageCacheManager(),
                monster: monster
            )
        }
        interactor.presenter = presenter

        return view
    }

    // MARK: Other Private Methods

}

extension MonsterDetailRouter: MonsterDetailRouterInput {

    func popupDancingImage(_ dancingImage: UIImage) {
        ImagePopupRouter.show(viewController, image: dancingImage)
    }

    func showActivity(_ senderView: UIView, text: String, icon: UIImage) {
        ActivityRouter.show(viewController, sourceView: senderView, text: text, url: nil, image: icon)
    }

}
