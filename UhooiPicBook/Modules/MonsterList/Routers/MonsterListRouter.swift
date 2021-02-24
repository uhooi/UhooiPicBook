//
//  MonsterListRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit

/// @mockable
protocol MonsterListRouterInput: AnyObject {
    func showMonsterDetail(monster: MonsterEntity)

    // Menu
    func showPrivacyPolicy()
    func showSettings()
}

final class MonsterListRouter {

    // MARK: Stored Instance Properties

    private unowned let viewController: MonsterListViewController

    // MARK: Initializers

    private init(viewController: MonsterListViewController) {
        self.viewController = viewController
    }

    // MARK: Type Methods

    static func assembleModule() -> MonsterListViewController {
        guard let view = R.storyboard.monsterList.instantiateInitialViewController() else {
            fatalError("Fail to load MonsterListViewController from Storyboard.")
        }
        let imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager()
        let interactor = MonsterListInteractor(monstersRepository: MonstersFirebaseClient(),
                                               monstersTempRepository: UserDefaultsClient(),
                                               spotlightRepository: SpotlightClient(imageCacheManager: imageCacheManager))
        let router = MonsterListRouter(viewController: view)
        let presenter = MonsterListPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        view.imageCacheManager = imageCacheManager
        interactor.presenter = presenter

        return view
    }

    // MARK: Other Private Methods

}

extension MonsterListRouter: MonsterListRouterInput {

    func showMonsterDetail(monster: MonsterEntity) {
        let vc = MonsterDetailRouter.assembleModule(monster: monster)
        self.viewController.navigationController?.pushViewController(vc, animated: true)
    }

    func showPrivacyPolicy() {
        guard let privacyPolicyUrl = URL(string: "https://theuhooi.com/privacy-policy/") else {
            fatalError("Fail to Initialize privacy policy URL.")
        }
        UIApplication.shared.open(privacyPolicyUrl)
    }

    func showSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsUrl)
        else {
            fatalError("Fail to open Settings URL.")
        }
        UIApplication.shared.open(settingsUrl)
    }

}
