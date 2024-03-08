//
//  NetworkManager.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/7/24.
//

import Foundation

protocol NetworkManager {
    var apiURL: URL? { get }
    
    func fetchData(endpointPath: String) async -> Result<Data, Error>
    func fetchDataWithQueries(endpointPath: String, queryParams: [URLQueryItem]) async -> Result<Data, Error>
    func onAsyncHttpResponse(data: Data, response: URLResponse) -> Result<Data, Error>
}

struct AppNetworkManager: NetworkManager {
    private let session: URLSession
    private let baseUrlString: String
    
    init(baseUrlString: String = "https://themealdb.com/api/json/v1/1", session: URLSession = .shared) {
        self.baseUrlString = baseUrlString
        self.session = session
    }
    
    var apiURL: URL? {
        return URL(string: baseUrlString)
    }

    enum NetworkError: Error {
        case invalidURL
        case unexpectedResponse
        case clientErrorCode
        case serverErrorCode
        case unexpectedStatusCode
    }

    /// Makes a GET request to the given endpoint appending the path to the NetworkManager's base API URL
    func fetchData(endpointPath: String) async -> Result<Data, Error> {
        guard let apiURL = apiURL else { return .failure(NetworkError.invalidURL) }
        
        let endpointURL = apiURL.appendingPathComponent(endpointPath)

        do {
            let (data, response) = try await session.data(from: endpointURL)
            return onAsyncHttpResponse(data: data, response: response)
        }
        catch {
            return .failure(error)
        }
    }
    
    /// Makes a GET request to the given endpoint appending the path to the NetworkManager's base API URL
    /// Then it appends the list of query parameters to the endpointPath
    func fetchDataWithQueries(endpointPath: String, queryParams: [URLQueryItem]) async -> Result<Data, Error> {
        guard let apiURL = apiURL else { return .failure(NetworkError.invalidURL) }
        
        let endpointURL = apiURL.appendingPathComponent(endpointPath)
        let urlWithQueryParams = endpointURL.appending(queryItems: queryParams)

        do {
            let (data, response) = try await session.data(from: urlWithQueryParams)
            return onAsyncHttpResponse(data: data, response: response)
        }
        catch {
            return .failure(error)
        }
    }
    
    /// Checks the returned Response from URLSession.data(from:) to ensure it is the expected Response type and expected 200 to 299 HTTP Status Codes
    /// Returns the data received in a Result.success(Success) wrapper.
    /// If any unexpected response received, then an error is returned in a Result.failure(Failure) wrapper
    internal func onAsyncHttpResponse(data: Data, response: URLResponse) -> Result<Data, Error> {
        guard let response = response as? HTTPURLResponse else { return .failure(NetworkError.unexpectedResponse) }
        
        guard (200...299).contains(response.statusCode) else {
            let networkError: NetworkError
            if response.statusCode > 499 {
                networkError = .serverErrorCode
            }
            else if response.statusCode > 399 {
                networkError = .clientErrorCode
            }
            else {
                networkError = .unexpectedStatusCode
            }
            return .failure(networkError)
        }
        
        return .success(data)
    }
}
