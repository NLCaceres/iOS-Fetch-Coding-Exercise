//
//  MockNetworkManager.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/8/24.
//

@testable import FetchMealCodingExercise
import Foundation

class MockNetworkManager: NetworkManager {
    var apiURL: URL? { return URL(string: "http://example.com") }
    var replacementData: Data?
    var error: Error?
    
    func fetchData(endpointPath: String) async -> Result<Data, Error> {
        if let error = error { return .failure(error) }

        guard let replacementData = replacementData else {
            fatalError("Replacement data should be set for comparison sake")
        }

        return .success(replacementData)
    }
    
    func fetchDataWithQueries(endpointPath: String, queryParams: [URLQueryItem]) async -> Result<Data, Error> {
        if let error = error { return .failure(error) }

        guard let replacementData = replacementData else {
            fatalError("Replacement data should be set for comparison sake")
        }

        return .success(replacementData)
    }
    
    func onAsyncHttpResponse(data: Data, response: URLResponse) -> Result<Data, Error> {
        return .success(Data())
    }
    
    
}
