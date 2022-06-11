//
//  URLSession+Async.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/12/14.
//

import Foundation

@available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            self.dataTask(with: url) { data, response, error in
                if let error {
                    return continuation.resume(throwing: error)
                }
                guard let data = data, let response = response else {
                    return continuation.resume(throwing: URLError(.badServerResponse))
                }
                continuation.resume(returning: (data, response))
            }.resume()
        }
    }
}
