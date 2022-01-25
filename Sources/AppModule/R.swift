//
//  R.swift
//
//
//  Created by uhooi on 2022/01/10.
//

import UIKit

enum R { // swiftlint:disable:this type_name
    enum LocalizedString {

        // MARK: Internal Stored Type Properties

        // Monster detail
        static let uhooiPicBookHashtag = nsLocalizedString("UhooiPicBook hashtag")

        // Menu
        static let contactUs = nsLocalizedString("Contact us")
        static let privacyPolicy = nsLocalizedString("Privacy policy")
        static let licenses = nsLocalizedString("Licenses")
        static let aboutThisApp = nsLocalizedString("About this app")

        // Contact us
        static let contactUsURL = nsLocalizedString("Contact us URL")

        // Privacy policy
        static let privacyPolicyURL = nsLocalizedString("Privacy policy URL")

        // About this app
        static let thisAppIsOpenSourceSoftware = nsLocalizedString("This app is open source software")
        static let uhooiPicBookGitHubURL = nsLocalizedString("UhooiPicBook GitHub URL")
        static let version = nsLocalizedString("Version")
        static let copyright = nsLocalizedString("Copyright")

        // Alert
        static let oK = nsLocalizedString("OK")

        // MARK: Other Private Type Methods

        private static func nsLocalizedString(_ key: String) -> String {
            NSLocalizedString(key, bundle: .module, comment: key) // swiftlint:disable:this nslocalizedstring_key
        }
    }

    enum Color {

        // MARK: Internal Stored Type Properties

        static let navigationBar = uiColor(named: "NavigationBar")

        // MARK: Other Private Type Methods

        private static func uiColor(named name: String) -> UIColor {
            guard let color = UIColor(named: name, in: .module, compatibleWith: nil) else {
                fatalError("Fail to load '\(name)' color.")
            }
            return color
        }
    }

    enum Storyboard {

        // MARK: Enums

        // swiftlint:disable nesting
        enum MonsterList {
            static func instantiateInitialViewController() -> MonsterListViewController {
                Storyboard.instantiateInitialViewController(named: "MonsterList")
            }
        }
        enum MonsterDetail {
            static func instantiateInitialViewController() -> MonsterDetailViewController {
                Storyboard.instantiateInitialViewController(named: "MonsterDetail")
            }
        }
        enum ImagePopup {
            static func instantiateInitialViewController() -> ImagePopupViewController {
                Storyboard.instantiateInitialViewController(named: "ImagePopup")
            }
        }
        enum InAppWebBrowser {
            static func instantiateInitialViewController() -> InAppWebBrowserViewController {
                Storyboard.instantiateInitialViewController(named: "InAppWebBrowser")
            }
        }
        // swiftlint:enable nesting

        // MARK: Other Private Type Methods

        private static func instantiateInitialViewController<T: UIViewController>(named name: String) -> T {
            guard let vc = uiStoryboard(name: name).instantiateInitialViewController() as? T else {
                fatalError("Fail to load \(T.self) from '\(name)' Storyboard.")
            }
            return vc
        }

        private static func uiStoryboard(name: String) -> UIStoryboard {
            UIStoryboard(name: name, bundle: .module)
        }
    }

    enum Nib {

        // MARK: Internal Stored Type Properties

        static let monsterCollectionViewCell = uiNib(name: "MonsterCollectionViewCell")

        // MARK: Other Private Type Methods

        private static func uiNib(name: String) -> UINib {
            UINib(nibName: name, bundle: .module)
        }
    }
}
