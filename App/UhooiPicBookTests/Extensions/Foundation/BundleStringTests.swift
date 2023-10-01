//
//  BundleStringTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 2021/02/25.
//

import XCTest
import Testing
@testable import AppModule

struct BundleStringTests {

    // MARK: TestCase Life-Cycle Methods

    init() {}

    // MARK: - Test Methods

    // MARK: displayName
    
    @Test
    func bundle_displayName() {
        guard let language = Locale.preferredLanguages.first else {
            Issue.record("Fail to load user's preferred languages.")
            return
        }

        let expected = switch Locale(identifier: language).languageCode {
        case "en": "UhooiPicBook"
        default: "ウホーイ図鑑"
        }
        #expect(Bundle.main.displayName == expected)
    }
    
    // MARK: version
    
    @Test
    func bundle_version() {
        #expect(Bundle.main.version == "1.6.0")
    }
    
    // MARK: build
    
    @Test
    func bundle_build() {
        #expect(Bundle.main.build == "17")
    }
}
