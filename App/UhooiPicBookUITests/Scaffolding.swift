//
//  Scaffolding.swift
//  UhooiPicBookUITests
//
//  Created by uhooi on 2023/10/02.
//

import XCTest
import Testing

final class AllTests: XCTestCase {
    func testAll() async {
        await XCTestScaffold.runAllTests(hostedBy: self)
    }
}
