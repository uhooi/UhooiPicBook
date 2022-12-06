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
        static let uhooiPicBookHashtag = string(localized: "UhooiPicBook hashtag")

        // Menu
        static let contactUs = string(localized: "Contact us")
        static let privacyPolicy = string(localized: "Privacy policy")
        static let licenses = string(localized: "Licenses")
        static let aboutThisApp = string(localized: "About this app")

        // Contact us
        static let contactUsURL = string(localized: "Contact us URL")

        // Privacy policy
        static let privacyPolicyURL = string(localized: "Privacy policy URL")

        // About this app
        static let thisAppIsOpenSourceSoftware = string(localized: "This app is open source software")
        static let uhooiPicBookGitHubURL = string(localized: "UhooiPicBook GitHub URL")
        static let version = string(localized: "Version")
        static let copyright = string(localized: "Copyright")

        // Alert
        static let oK = string(localized: "OK")

        // MARK: Other Private Type Methods

        private static func string(localized keyAndValue: String.LocalizationValue) -> String {
            String(localized: keyAndValue, bundle: .module)
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

    @MainActor
    enum Storyboard {

        // MARK: Enums

        // swiftlint:disable nesting
        @MainActor
        enum MonsterList {
            static func instantiateInitialViewController() -> MonsterListViewController {
                Storyboard.instantiateInitialViewController(named: "MonsterList")
            }
        }
        @MainActor
        enum MonsterDetail {
            static func instantiateInitialViewController() -> MonsterDetailViewController {
                Storyboard.instantiateInitialViewController(named: "MonsterDetail")
            }
        }
        @MainActor
        enum ImagePopup {
            static func instantiateInitialViewController() -> ImagePopupViewController {
                Storyboard.instantiateInitialViewController(named: "ImagePopup")
            }
        }
        @MainActor
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

    @MainActor
    enum Nib {

        // MARK: Internal Stored Type Properties

        static let monsterCollectionViewCell = uiNib(name: "MonsterCollectionViewCell")

        // MARK: Other Private Type Methods

        private static func uiNib(name: String) -> UINib {
            UINib(nibName: name, bundle: .module)
        }
    }
}
