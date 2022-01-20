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
        static let uhooiPicBookHashtag = createNSLocalizedString("UhooiPicBook hashtag")

        // Menu
        static let contactUs = createNSLocalizedString("Contact us")
        static let privacyPolicy = createNSLocalizedString("Privacy policy")
        static let licenses = createNSLocalizedString("Licenses")
        static let aboutThisApp = createNSLocalizedString("About this app")

        // Contact us
        static let contactUsURL = createNSLocalizedString("Contact us URL")

        // Privacy policy
        static let privacyPolicyURL = createNSLocalizedString("Privacy policy URL")

        // About this app
        static let thisAppIsOpenSourceSoftware = createNSLocalizedString("This app is open source software")
        static let uhooiPicBookGitHubURL = createNSLocalizedString("UhooiPicBook GitHub URL")
        static let version = createNSLocalizedString("Version")
        static let copyright = createNSLocalizedString("Copyright")

        // Alert
        static let oK = createNSLocalizedString("OK")

        // MARK: Other Private Type Methods

        private static func createNSLocalizedString(_ key: String) -> String {
            NSLocalizedString(key, bundle: .module, comment: key) // swiftlint:disable:this nslocalizedstring_key
        }
    }

    enum Color {

        // MARK: Internal Stored Type Properties

        static let navigationBar = createUIColor(named: "NavigationBar")

        // MARK: Other Private Type Methods

        private static func createUIColor(named name: String) -> UIColor {
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
                Storyboard.instantiateInitialViewController("MonsterList")
            }
        }
        enum MonsterDetail {
            static func instantiateInitialViewController() -> MonsterDetailViewController {
                Storyboard.instantiateInitialViewController("MonsterDetail")
            }
        }
        enum ImagePopup {
            static func instantiateInitialViewController() -> ImagePopupViewController {
                Storyboard.instantiateInitialViewController("ImagePopup")
            }
        }
        enum InAppWebBrowser {
            static func instantiateInitialViewController() -> InAppWebBrowserViewController {
                Storyboard.instantiateInitialViewController("InAppWebBrowser")
            }
        }
        // swiftlint:enable nesting

        // MARK: Other Private Type Methods

        private static func instantiateInitialViewController<T: UIViewController>(_ name: String) -> T {
            guard let vc = createUIStoryboard(name: name).instantiateInitialViewController() as? T else {
                fatalError("Fail to load \(T.self) from '\(name)' Storyboard.")
            }
            return vc
        }

        private static func createUIStoryboard(name: String) -> UIStoryboard {
            UIStoryboard(name: name, bundle: .module)
        }
    }

    enum Nib {

        // MARK: Internal Stored Type Properties

        static let monsterCollectionViewCell = createNib(name: "MonsterCollectionViewCell")

        // MARK: Other Private Type Methods

        private static func createNib(name: String) -> UINib {
            UINib(nibName: name, bundle: .module)
        }
    }
}
