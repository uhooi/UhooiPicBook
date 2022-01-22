//
//  R.swift
//
//
//  Created by uhooi on 2022/01/09.
//

import Foundation
import UIKit.UIImage

public enum R { // swiftlint:disable:this type_name
    public enum LocalizedString {

        // MARK: Public Stored Type Properties

        public static let configurationDisplayName = nsLocalizedString("Configuration display name")
        public static let configurableDescription = nsLocalizedString("Configurable description")

        // MARK: Internal Stored Type Properties

        static let description = nsLocalizedString("Description")

        // MARK: Other Private Type Methods

        private static func nsLocalizedString(_ key: String) -> String {
            NSLocalizedString(key, bundle: .module, comment: key) // swiftlint:disable:this nslocalizedstring_key
        }
    }

    enum Image {

        // MARK: Internal Stored Type Properties

        static let uhooiIcon = createUIImage(named: "Uhooi")

        // MARK: Other Private Type Methods

        private static func createUIImage(named name: String) -> UIImage {
            guard let image = UIImage(named: name, in: .module, with: nil) else {
                fatalError("Fail to load '\(name)' image.")
            }
            return image
        }
    }
}
