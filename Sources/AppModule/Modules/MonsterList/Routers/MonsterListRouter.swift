//
//  MonsterListRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit
import ImageCache

/// @mockable
@MainActor
protocol MonsterListRouterInput: AnyObject {
    func showMonsterDetail(monster: MonsterEntity)

    // Menu
    func showContactUs()
    func showPrivacyPolicy()
    func showSettings()
    func showAboutThisApp()
}

@MainActor
public final class MonsterListRouter {

    // MARK: Stored Instance Properties

    private unowned let viewController: MonsterListViewController

    // MARK: Initializers

    private init(viewController: MonsterListViewController) {
        self.viewController = viewController
    }

    // MARK: Type Methods

    public static func assembleModule() -> MonsterListViewController {
        let view = R.Storyboard.MonsterList.instantiateInitialViewController()
        let router = MonsterListRouter(viewController: view)
        let imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager()
        let interactor = MonsterListInteractor(
            spotlightRepository: SpotlightClient(imageCacheManager: imageCacheManager)
        )
        let presenter = MonsterListPresenter(view: view, interactor: interactor, router: router)

        view.inject(presenter: presenter, imageCacheManager: imageCacheManager)
        interactor.presenter = presenter

        return view
    }

    // MARK: Other Private Methods

}

extension MonsterListRouter: MonsterListRouterInput {

    func showMonsterDetail(monster: MonsterEntity) {
        let vc = MonsterDetailRouter.assembleModule(monster: monster)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }

    func showContactUs() {
        guard let contactUsUrl = URL(string: R.LocalizedString.contactUsURL) else {
            fatalError("Fail to initialize contact us URL.")
        }
        InAppWebBrowserRouter.show(viewController, url: contactUsUrl)
    }

    func showPrivacyPolicy() {
        guard let privacyPolicyUrl = URL(string: R.LocalizedString.privacyPolicyURL) else {
            fatalError("Fail to initialize privacy policy URL.")
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
\(R.LocalizedString.thisAppIsOpenSourceSoftware)
\(R.LocalizedString.uhooiPicBookGitHubURL)

\(R.LocalizedString.version) \(Bundle.main.version) (\(Bundle.main.build))
\(R.LocalizedString.copyright)
"""
        let okAction = UIAlertAction(title: R.LocalizedString.oK, style: .default) { _ in }
        viewController.showAlert(title: title, message: message, actions: [okAction])
    }

}
