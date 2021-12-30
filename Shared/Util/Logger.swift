//
//  Logger.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/12/30.
//

import Foundation
import os.log

enum LogCategory: String {
    case `default`
}

protocol LoggerProtocol {
    func debug(_ message: String, file: String, function: String, line: Int, column: Int)
    func info(_ message: String, file: String, function: String, line: Int, column: Int)
    func notice(_ message: String, file: String, function: String, line: Int, column: Int)
    func error(_ message: String, file: String, function: String, line: Int, column: Int)
    func fault(_ message: String, file: String, function: String, line: Int, column: Int)
    func exception(_ error: Error, file: String, function: String, line: Int, column: Int)
}

final class Logger {
    static let `default` = Logger(category: .default)

    let logger: os.Logger

    init(category: LogCategory) {
        self.logger = os.Logger(
            subsystem: Bundle.main.bundleIdentifier!, // swiftlint:disable:this force_unwrapping
            category: category.rawValue
        )
    }
}

extension Logger: LoggerProtocol {
    func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        let logRow = createLogRowString(message, file: file, function: function, line: line, column: column)
        logger.debug("\(logRow, privacy: .public)")
    }

    func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        let logRow = createLogRowString(message, file: file, function: function, line: line, column: column)
        logger.info("\(logRow, privacy: .public)")
    }

    func notice(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        let logRow = createLogRowString(message, file: file, function: function, line: line, column: column)
        logger.notice("\(logRow, privacy: .public)")
    }

    func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        let logRow = createLogRowString(message, file: file, function: function, line: line, column: column)
        logger.error("\(logRow, privacy: .public)")
    }

    func fault(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        let logRow = createLogRowString(message, file: file, function: function, line: line, column: column)
        logger.fault("\(logRow, privacy: .public)")
    }

    func exception(
        _ error: Error,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        self.fault(error.localizedDescription, file: file, function: function, line: line, column: column)
    }

    private func createLogRowString(
        _ message: String,
        file: String,
        function: String,
        line: Int,
        column: Int
    ) -> String {
        "\(file) \(function) (Line: \(line), Column: \(column)): \(message)"
    }

}
