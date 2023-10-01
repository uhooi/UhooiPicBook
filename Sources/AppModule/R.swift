//
//  R.swift
//
//
//  Created by uhooi on 2022/01/10.
//

import UIKit

enum R { // swiftlint:disable:this type_name
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
