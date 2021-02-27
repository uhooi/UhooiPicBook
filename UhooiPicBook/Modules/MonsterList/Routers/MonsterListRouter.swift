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
    func showContactUs()
    func showPrivacyPolicy()
    func showSettings()
    func showAboutThisApp()
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

    func showContactUs() {
        guard let contactUsUrl = URL(string: R.string.localizable.contactUsURL()) else {
            fatalError("Fail to Initialize contact us URL.")
        }
        InAppWebBrowserRouter.show(self.viewController, url: contactUsUrl)
    }

    func showPrivacyPolicy() {
        guard let privacyPolicyUrl = URL(string: R.string.localizable.privacyPolicyURL()) else {
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

    func showAboutThisApp() {
        let title = Bundle.main.displayName
        let message = """
\(R.string.localizable.thisAppIsOpenSourceSoftware())
\(R.string.localizable.uhooiPicBookGitHubURL())

\(R.string.localizable.version()) \(Bundle.main.version) (\(Bundle.main.build))
\(R.string.localizable.copyright())
"""
        let okAction = UIAlertAction(title: R.string.localizable.oK(), style: .default) { _ in }
        self.viewController.showAlert(title: title, message: message, actions: [okAction])
    }

}
