//
//  BundleVersionTests.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 2021/02/25.
//

import XCTest
@testable import UhooiPicBook

final class BundleVersionTests: XCTestCase {

    // MARK: TestCase Life-Cycle Methods

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Test Methods

    // MARK: version
    
    func test_bundle_version() {
        XCTAssertEqual(Bundle.main.version, "1.3.0")
    }
    
    // MARK: build
    
    func test_bundle_build() {
        XCTAssertEqual(Bundle.main.build, "14")
    }

}
