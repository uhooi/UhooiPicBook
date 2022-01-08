// swiftlint:disable:this file_name
//
//  Resources.swift
//
//
//  Created by uhooi on 2022/01/09.
//

import Foundation
import UIKit.UIImage

public enum R { // swiftlint:disable:this type_name
    public enum LocalizedString {
        public static let configurationDisplayName = NSLocalizedString(
            "Configuration display name",
            bundle: .module,
            comment: "Configuration display name"
        )

        public static let configurableDescription = NSLocalizedString(
            "Configurable description",
            bundle: .module,
            comment: "Configurable description"
        )

        static let description = NSLocalizedString(
            "Description",
            bundle: .module,
            comment: "Description"
        )
    }

    enum Image {
        static let uhooiIcon = UIImage(
            named: "Uhooi",
            in: .module,
            with: nil
        )! // swiftlint:disable:this force_unwrapping
    }
}
