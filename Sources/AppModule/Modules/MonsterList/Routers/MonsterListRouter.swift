//
//  MonsterListRouter.swift
//  UhooiPicBook
//
//  Created by uhooi on 28/02/2020.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit
import MonstersRepository

/// @mockable
@MainActor
protocol MonsterListRouterInput: AnyObject {
    func showMonsterDetail(monster: MonsterItem)

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
        typealias SC = SpotlightClient // swiftlint:disable:this type_name
        let interactor = MonsterListInteractor<
            SC,
            MonstersFirestoreClient,
            UserDefaultsClient
        >(spotlightRepository: SC())
        let router = MonsterListRouter(viewController: view)
        let presenter = MonsterListPresenter(view: view, interactor: interactor, router: router)

        let sections: [any CollectionSectionProtocol] = [
            MonsterCollectionSection(presenter: presenter)
        ]
        view.inject(sections: sections, presenter: presenter)
        interactor.inject(presenter: presenter)

        return view
    }
}

extension MonsterListRouter: MonsterListRouterInput {
    func showMonsterDetail(monster: MonsterItem) {
        let vc = MonsterDetailRouter.assembleModule(monster: monster)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }

    func showContactUs() {
        guard let contactUsURL = URL(string: R.LocalizedString.contactUsURL) else {
            fatalError("Fail to initialize contact us URL.")
        }
        InAppWebBrowserRouter.show(viewController, url: contactUsURL)
    }

    func showPrivacyPolicy() {
        guard let privacyPolicyURL = URL(string: R.LocalizedString.privacyPolicyURL) else {
            fatalError("Fail to initialize privacy policy URL.")
        }
        UIApplication.shared.open(privacyPolicyURL)
    }

    func showSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL)
        else {
            fatalError("Fail to open Settings URL.")
        }
        UIApplication.shared.open(settingsURL)
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
