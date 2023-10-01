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
        let router = Self(viewController: view)
        let presenter = MonsterListPresenter(view: view, interactor: interactor, router: router)

        let sections: [any CollectionSectionProtocol] = [
            MonsterCollectionSection(presenter: presenter)
        ]
        view.inject(presenter: presenter, sections: sections)
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
        let contactUsURL = URL(string: String(localized: "Contact us URL", bundle: .module))!
        InAppWebBrowserRouter.show(viewController, url: contactUsURL)
    }

    func showPrivacyPolicy() {
        let privacyPolicyURL = URL(string: String(localized: "Privacy policy URL", bundle: .module))!
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
\(String(localized: "This app is open source software", bundle: .module))
\(String(localized: "UhooiPicBook GitHub URL", bundle: .module))

\(String(localized: "Version", bundle: .module)) \(Bundle.main.version) (\(Bundle.main.build))
\(String(localized: "Copyright", bundle: .module))
"""
        let okAction = UIAlertAction(title: String(localized: "OK", bundle: .module), style: .default) { _ in }
        viewController.showAlert(title: title, message: message, actions: [okAction])
    }
}
