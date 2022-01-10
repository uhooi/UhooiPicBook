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

        public static let configurationDisplayName = createNSLocalizedString("Configuration display name")
        public static let configurableDescription = createNSLocalizedString("Configurable description")

        // MARK: Internal Stored Type Properties

        static let description = createNSLocalizedString("Description")

        // MARK: Other Private Type Methods

        private static func createNSLocalizedString(_ key: String) -> String {
            NSLocalizedString(key, bundle: .module, comment: key) // swiftlint:disable:this nslocalizedstring_key
        }
    }

    enum Image {

        // MARK: Internal Stored Type Properties

        static let uhooiIcon = createUIImage(named: "Uhooi")

        // MARK: Other Private Type Methods

        private static func createUIImage(named name: String, line: UInt = #line) -> UIImage {
            guard let image = UIImage(named: name, in: .module, with: nil) else {
                fatalError("Fail to load '\(name)' image.", line: line)
            }
            return image
        }
    }
}
