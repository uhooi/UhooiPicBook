//
//  BundleVersionTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 2021/02/25.
//

import XCTest
@testable import AppModule

final class BundleStringTests: XCTestCase {

    // MARK: TestCase Life-Cycle Methods

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: displayName
    
    func test_bundle_displayName() {
        guard let language = Locale.preferredLanguages.first else {
            XCTFail("Fail to load user's preferred languages.")
            return
        }

        var expected = ""
        switch Locale(identifier: language).languageCode {
        case "en":
            expected = "UhooiPicBook"
        default:
            expected = "ウホーイ図鑑"
        }
        XCTAssertEqual(Bundle.main.displayName, expected)
    }
    
    // MARK: version
    
    func test_bundle_version() {
        XCTAssertEqual(Bundle.main.version, "1.6.0")
    }
    
    // MARK: build
    
    func test_bundle_build() {
        XCTAssertEqual(Bundle.main.build, "17")
    }
}
