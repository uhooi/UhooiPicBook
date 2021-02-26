//
//  Bundle+String.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/02/25.
//

import Foundation

extension Bundle {
    var displayName: String {
        guard let displayName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String else {
            fatalError("Fail to load Display Name.")
        }
        return displayName
    }

    var version: String {
        guard let version = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("Fail to load Version.")
        }
        return version
    }

    var build: String {
        guard let build = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("Fail to load Build.")
        }
        return build
    }
}
