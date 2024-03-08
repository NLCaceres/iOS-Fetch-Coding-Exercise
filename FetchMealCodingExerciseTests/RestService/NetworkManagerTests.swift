//
//  NetworkManagerTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/8/24.
//

@testable import FetchMealCodingExercise
import XCTest

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!

    enum MockError: Int, Error {
        case someError = 1234
    }

    override func setUp() {
        networkManager = AppNetworkManager(session: MockURLSession.stubURLSession())
    }
    override func tearDown() {
        networkManager = nil
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = nil
    }

    func testApiURL() throws {
        let normalNetworkManager = AppNetworkManager()
        // WHEN no baseUrlString provided, THEN it defaults to "theMealDb.com"
        XCTAssertEqual(normalNetworkManager.apiURL!.absoluteString, "https://themealdb.com/api/json/v1/1")
        
        let networkManagerWithDifferentURL = AppNetworkManager(baseUrlString: "http://example.com/")
        // WHEN a baseUrlString provided, THEN it completely overrides the apiURL's underlying absolute string
        XCTAssertEqual(networkManagerWithDifferentURL.apiURL!.absoluteString, "http://example.com/")
    }
    func testBadApiURL() async throws {
        let badNetworkManager = AppNetworkManager(baseUrlString: "abc/${def}", session: MockURLSession.stubURLSession())
        // WHEN URL(string:) is initialized with a string that contains the "$" (a reserved char) followed by "{"
        // THEN the init will fail, so the NetworkManager's apiURL will be nil
        XCTAssertNil(badNetworkManager.apiURL)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: [:])!
            return (response, Data("Foobar".utf8))
        }
        let result = await badNetworkManager.fetchData(endpointPath: "foo")
        // WHEN attempting to access the apiURL that's nil, THEN fetch requests will fail due to invalid URL
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as! AppNetworkManager.NetworkError, AppNetworkManager.NetworkError.invalidURL)
        }
    }

    func testFetchDataFails() async throws {
        MockURLProtocol.error = MockError.someError
        let result = await networkManager.fetchData(endpointPath: "/foo")
        // WHEN the networkManager's data request fails, THEN the error is caught and returned in the Result wrapper
        XCTAssertThrowsError(try result.get()) { error in
            // WHEN checking that result, THEN it'll fail throwing an NSURLError wrapping the caught error
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 1234) // A code equal to 1234 indicates my MockError was caught!
        }
    }
    func testFetchData() async throws {
        MockURLProtocol.requestHandler = { request in
            // WHEN making a fetch request with the default URL, THEN the endpoint from fetchData(endpointPath:) is appended to the apiURL
            XCTAssertEqual(request.url!.absoluteString, "https://themealdb.com/api/json/v1/1/foo")
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: [:])!
            return (response, Data("Foobar".utf8))
        }
        // WHEN Data containing a string "Foobar" is sent back in fetchData's response
        let result = await networkManager.fetchData(endpointPath: "foo")
        let resultDecoded = String(decoding: try! result.get(), as: UTF8.self)
        // THEN it is found in the returned Result wrapper
        XCTAssertEqual(resultDecoded, "Foobar")
    }
    
    func testFetchDataWithQueryFails() async throws {
        MockURLProtocol.error = MockError.someError
        // WHEN the networkManager's data request fails
        let result = await networkManager.fetchDataWithQueries(endpointPath: "bar", queryParams: [URLQueryItem(name: "abc", value: "def")])
        // THEN the queries are ignored, and a failure Result is returned, throwing an NSURLError containing my MockError
        XCTAssertThrowsError(try result.get()) { error in
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 1234)
        }
    }
    func testFetchDataWithQuery() async throws {
        MockURLProtocol.requestHandler = { request in
            // WHEN no query params are provided to the fetchWithQueries func, THEN the url ends with a "?" BUT no parameters or values
            XCTAssertEqual(request.url!.absoluteString, "https://themealdb.com/api/json/v1/1/foo?")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: [:])!
            return (response, Data("Barfoo".utf8))
        }
        // WHEN Data containing a string "Barfoo" is returned from fetchDataWithQueries
        let result = await networkManager.fetchDataWithQueries(endpointPath: "foo", queryParams: [])
        let resultDecoded = String(decoding: try! result.get(), as: UTF8.self)
        // THEN it is safely unwrapped from the Result
        XCTAssertEqual(resultDecoded, "Barfoo")
        
        MockURLProtocol.requestHandler = { request in
            // WHEN query params provided, THEN the url appends all params separated by "&"
            XCTAssertEqual(request.url!.absoluteString, "https://themealdb.com/api/json/v1/1/boo?abc=def&fizz=buzz")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: [:])!
            return (response, Data("Fizzbuzz".utf8))
        }
        // WHEN Data containing a string "Fizzbuzz" is returned from fetchDataWithQueries
        let queries = [URLQueryItem(name: "abc", value: "def"), URLQueryItem(name: "fizz", value: "buzz")]
        let queryResult = await networkManager.fetchDataWithQueries(endpointPath: "boo", queryParams: queries)
        let queryResultDecoded = String(decoding: try! queryResult.get(), as: UTF8.self)
        // THEN it is safely retrieved from the Result
        XCTAssertEqual(queryResultDecoded, "Fizzbuzz")
    }

    func testOnUnexpectedResponse() async throws {
        let stringData = Data("Foo".utf8)
        // WHEN the response handler receives a URLResponse that CANNOT be cast into an HTTPURLResponse
        let response = URLResponse(url: URL(string: "foo")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let result = networkManager.onAsyncHttpResponse(data: stringData, response: response)
        // THEN the Result wrapper will throw an unexpectedResponse error when attempting to unwrap
        XCTAssertThrowsError(try result.get()) { error in
            XCTAssertEqual(error as! AppNetworkManager.NetworkError, AppNetworkManager.NetworkError.unexpectedResponse)
        }
    }
    func testOnUnexpectedStatusCodeResponse() async throws {
        let stringData = Data("Foo".utf8)
        // WHEN the response handler receives a URLResponse that doesn't have a 200-299 HTTP status code
        let url = URL(string: "http://example.com")!
        let serverErrorResponse = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let serverErrorResult = networkManager.onAsyncHttpResponse(data: stringData, response: serverErrorResponse)
        // THEN it receives a failure result containing one of three error codes
        XCTAssertThrowsError(try serverErrorResult.get()) { error in
            // WHEN the status code is 500 or HIGHER, THEN it will be a server error code
            XCTAssertEqual(error as! AppNetworkManager.NetworkError, AppNetworkManager.NetworkError.serverErrorCode)
        }
        
        let clientErrorResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
        let clientErrorResult = networkManager.onAsyncHttpResponse(data: stringData, response: clientErrorResponse)
        XCTAssertThrowsError(try clientErrorResult.get()) { error in
            // WHEN the status code is 400 or HIGHER (but under 500), THEN it will be a client error code
            XCTAssertEqual(error as! AppNetworkManager.NetworkError, AppNetworkManager.NetworkError.clientErrorCode)
        }
        
        let otherErrorResponse = HTTPURLResponse(url: url, statusCode: 300, httpVersion: nil, headerFields: nil)!
        let otherErrorResult = networkManager.onAsyncHttpResponse(data: stringData, response: otherErrorResponse)
        XCTAssertThrowsError(try otherErrorResult.get()) { error in
            // WHEN the status code is 300 or HIGHER (but under 400), THEN it will be a unexpected status error code
            XCTAssertEqual(error as! AppNetworkManager.NetworkError, AppNetworkManager.NetworkError.unexpectedStatusCode)
        }
    }
    func testOnSuccessfulResponse() async throws {
        let stringData = Data("Foo".utf8)
        // WHEN the response handler receives a URLResponse that has a status code between 200 and 299
        let url = URL(string: "http://example.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let result = networkManager.onAsyncHttpResponse(data: stringData, response: response)
        // THEN the result can be safely unwrapped to the expected Data sent
        let resultDecoded = String(data: try! result.get(), encoding: .utf8)
        XCTAssertEqual(resultDecoded, "Foo")
    }
}
