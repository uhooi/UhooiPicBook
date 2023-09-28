//
//  R.swift
//
//
//  Created by uhooi on 2022/01/09.
//

import Foundation
import class UIKit.UIImage

public enum R { // swiftlint:disable:this type_name
    public enum LocalizedString {

        // MARK: Public Stored Type Properties

        public static let configurationDisplayName = string(localized: "Configuration display name")
        public static let configurableDescription = string(localized: "Configurable description")

        // MARK: Internal Stored Type Properties

        static let description = string(localized: "Description")

        // MARK: Other Private Type Methods

        private static func string(localized keyAndValue: String.LocalizationValue) -> String {
            String(localized: keyAndValue, bundle: .module)
        }
    }
}
