//
//  Bundle+String.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/02/25.
//

import Foundation

extension Bundle {
    // swiftlint:disable force_cast
    var displayName: String { object(forInfoDictionaryKey: "CFBundleDisplayName") as! String }
    var version: String { object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String }
    var build: String { object(forInfoDictionaryKey: "CFBundleVersion") as! String }
    // swiftlint:enable force_cast
}
