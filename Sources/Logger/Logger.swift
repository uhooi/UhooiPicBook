//
//  Logger.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/12/30.
//

import Foundation
import os.log

public enum LogCategory: String {
    case `default`
}

/// @mockable
public protocol LoggerProtocol {
    func debug(_ message: String, file: String, function: String, line: Int, column: Int)
    func info(_ message: String, file: String, function: String, line: Int, column: Int)
    func notice(_ message: String, file: String, function: String, line: Int, column: Int)
    func error(_ message: String, file: String, function: String, line: Int, column: Int)
    func fault(_ message: String, file: String, function: String, line: Int, column: Int)
    func exception(_ error: Error, file: String, function: String, line: Int, column: Int)
}

extension LoggerProtocol { // swiftlint:disable:this file_types_order
    public func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        debug(message, file: file, function: function, line: line, column: column)
    }

    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        info(message, file: file, function: function, line: line, column: column)
    }

    public func notice(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        notice(message, file: file, function: function, line: line, column: column)
    }

    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        error(message, file: file, function: function, line: line, column: column)
    }

    public func fault(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        fault(message, file: file, function: function, line: line, column: column)
    }

    public func exception(_ error: Error, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
        exception(error, file: file, function: function, line: line, column: column)
    }
}

public final class Logger {

    // MARK: Stored Type Properties

    public static let `default` = Logger(category: .default)

    // MARK: Stored Instance Properties

    private let logger: os.Logger

    // MARK: Initializers

    public init(category: LogCategory) {
        self.logger = os.Logger(
            subsystem: Bundle.main.bundleIdentifier!, // swiftlint:disable:this force_unwrapping
            category: category.rawValue
        )
    }
}

extension Logger: LoggerProtocol {
    public func debug(_ message: String, file: String, function: String, line: Int, column: Int) {
        let logRow = logRow(message, file: file, function: function, line: line, column: column)
        logger.debug("\(logRow, privacy: .public)")
    }

    public func info(_ message: String, file: String, function: String, line: Int, column: Int) {
        let logRow = logRow(message, file: file, function: function, line: line, column: column)
        logger.info("\(logRow, privacy: .public)")
    }

    public func notice(_ message: String, file: String, function: String, line: Int, column: Int) {
        let logRow = logRow(message, file: file, function: function, line: line, column: column)
        logger.notice("\(logRow, privacy: .public)")
    }

    public func error(_ message: String, file: String, function: String, line: Int, column: Int) {
        let logRow = logRow(message, file: file, function: function, line: line, column: column)
        logger.error("\(logRow, privacy: .public)")
    }

    public func fault(_ message: String, file: String, function: String, line: Int, column: Int) {
        let logRow = logRow(message, file: file, function: function, line: line, column: column)
        logger.fault("\(logRow, privacy: .public)")
    }

    public func exception(_ error: Error, file: String, function: String, line: Int, column: Int) {
        self.error(error.localizedDescription, file: file, function: function, line: line, column: column)
    }

    // MARK: Other Private Methods

    private func logRow(_ message: String, file: String, function: String, line: Int, column: Int) -> String {
        "\(file) \(function) (Line: \(line), Column: \(column)): \(message)"
    }
}
