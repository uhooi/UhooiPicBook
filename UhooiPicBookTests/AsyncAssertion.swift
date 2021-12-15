//
//  AsyncAssertion.swift
//  UhooiPicBookTests
//
//  Created by uhooi on 2021/12/15.
//

import XCTest

func assertEqualAsync<T>(
    _ actual: @autoclosure () async -> T,
    _ expected: T,
    _ message: String = "",
    file: StaticString = #filePath,
    line: UInt = #line
)  async where T : Equatable {
    let actual = await actual()
    XCTAssertEqual(actual, expected, message, file: file, line: line)
}
