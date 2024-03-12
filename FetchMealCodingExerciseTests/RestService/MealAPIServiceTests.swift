//
//  MealAPIServiceTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/8/24.
//

@testable import FetchMealCodingExercise
import XCTest

final class MealAPIServiceTests: XCTestCase {
    var networkManager: MockNetworkManager!
    var mealAPI: MealApiService!
    
    override func setUpWithError() throws {
        networkManager = MockNetworkManager()
        mealAPI = AppMealApiService(networkManager: networkManager)
    }

    override func tearDownWithError() throws {
        networkManager = nil
        mealAPI = nil
    }

    func testGetMealListFilteredByCategory() async throws {
        let encoder = JSONEncoder()
        networkManager.replacementData = try! encoder.encode(["Foo": [Meal(id: "123", name: "Fizz", thumbnailUrlString: "example.com/123.jpg")]])
        // IF the REST API returns an object without a "meals" key containing an Array
        let resultDueToJsonMismatch = try await mealAPI.getMealListFiltered(byCategory: "Foo")
        // THEN the service returns an empty array
        XCTAssert(resultDueToJsonMismatch.isEmpty)
        
        let mealsUndecodableDict = ["meals": [["id": "123", "meal": "Foo", "mealThumb": "bar.jpg"]]]
        networkManager.replacementData = try! encoder.encode(mealsUndecodableDict)
        // WHEN the REST API returns data that can't be decoded into a Dictionary of [Meal], THEN the service throws, leaving behind nil with "try?"
        let nilDueToDecodingError = try? await mealAPI.getMealListFiltered(byCategory: "Foo")
        XCTAssertNil(nilDueToDecodingError)
        
        let mealsDict: [String: [Meal]?] = ["meals": nil]
        // This mealsDict encodes to { "meals": null }
        networkManager.replacementData = try! encoder.encode(mealsDict)
        // WHEN a null Array is returned from the REST API, THEN the service will throw since the decoded Dict handles non-optional Meal values
        let resultWithNilMealsArray = try? await mealAPI.getMealListFiltered(byCategory: "Foo")
        XCTAssertNil(resultWithNilMealsArray)
        
        networkManager.replacementData = try! encoder.encode(["meals": [Meal(id: "123", name: "Fizz", thumbnailUrlString: "example.com/123.jpg")]])
        // WHEN the REST API returns a typical response { "meals": [Meal] }
        let resultWithExpectedJSON = try await mealAPI.getMealListFiltered(byCategory: "Foo")
        let meal = resultWithExpectedJSON[0]
        // THEN it should be properly decoded, and each Meal can be read
        XCTAssertEqual(meal.id, "123")
        XCTAssertEqual(meal.name, "Fizz")
        XCTAssertEqual(meal.thumbnailUrlString, "example.com/123.jpg")
        
        networkManager.error = MockError.someError
        // WHEN the REST API fails, THEN the service throws leaving nil with "try?"
        let nilDueToNetworkError = try? await mealAPI.getMealListFiltered(byCategory: "Foo")
        XCTAssertNil(nilDueToNetworkError)
    }

    func testGetMealByID() async throws {
        let encoder = JSONEncoder()
        networkManager.replacementData = try! encoder.encode(["Foo": [Meal(id: "123", name: "Fizz", thumbnailUrlString: "example.com/123.jpg")]])
        // WHEN the REST API returns an object without a "meal" key containing an Array
        let resultDueToJsonMismatch = try await mealAPI.getMeal(byID: "Foo")
        // THEN the service will return nil
        XCTAssertNil(resultDueToJsonMismatch)
        
        let mealsUndecodableDict = ["meals": [["id": "123", "meal": "Foo", "mealThumb": "bar.jpg"]]]
        networkManager.replacementData = try! encoder.encode(mealsUndecodableDict)
        // WHEN the REST API returns data that can't be decoded into a Dictionary of [Meal], THEN it will throw
        let nilDueToDecodingError = try? await mealAPI.getMeal(byID: "Foo")
        XCTAssertNil(nilDueToDecodingError)
        
        let mealsDict: [String: [Meal]?] = ["meals": nil]
        networkManager.replacementData = try! encoder.encode(mealsDict)
        // WHEN a null Array is returned from the REST API, THEN the service will throw since the decoded Dict handles non-optional Meal values
        let resultWithNilMealsArray = try? await mealAPI.getMeal(byID: "Foo")
        XCTAssertNil(resultWithNilMealsArray)
        
        networkManager.replacementData = try! encoder.encode(["meals": [Meal(id: "123", name: "Fizz", thumbnailUrlString: "example.com/123.jpg")]])
        // WHEN the REST API returns a typical response { "meals": [Meal] }
        let resultWithExpectedJSON = try await mealAPI.getMeal(byID: "Foo")
        // THEN only one Meal is expected, so it's grabbed and returned by the service
        XCTAssertNotNil(resultWithExpectedJSON)
        XCTAssertEqual(resultWithExpectedJSON!.id, "123")
        XCTAssertEqual(resultWithExpectedJSON!.name, "Fizz")
        XCTAssertEqual(resultWithExpectedJSON!.thumbnailUrlString, "example.com/123.jpg")
        
        networkManager.error = MockError.someError
        // WHEN the REST API fails, THEN the service will throw
        let nilDueToNetworkError = try? await mealAPI.getMeal(byID: "Foo")
        // THEN the service returns nil
        XCTAssertNil(nilDueToNetworkError)
    }

}
