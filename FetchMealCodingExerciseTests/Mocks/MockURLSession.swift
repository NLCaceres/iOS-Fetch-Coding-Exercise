//
//  MockURLSession.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/8/24.
//

import Foundation

class MockURLSession: URLSession {
    /// Overrides the URLProtocol
    static func stubURLSession() -> URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
