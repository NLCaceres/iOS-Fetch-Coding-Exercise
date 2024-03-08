//
//  MockUrlProtocol.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/7/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var error: Error?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    /// Determines what URLRequests that this Protocol can handle
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    /// Returns the canonical version of any Request handled by this Protocol. It is up to the Protocol to determine what the canonical version entails.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// Begins loading the request
    /// If an error is set, then the client is informed of the error so it can handle it
    /// If a request handler closure is set, then it is called. The Response and Data returned by the closure are delivered to the client to handle.
    /// If no request handler is set, then this method will fail
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Request handler has not been set.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
        catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    /// Stops an in-progress request and prevents the client from receiving any response
    override func stopLoading() { }
}
