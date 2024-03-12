//
//  DessertListViewModelTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/10/24.
//

@testable import FetchMealCodingExercise
import XCTest

final class DessertListViewModelTests: XCTestCase {
    var apiService: MockMealAPIService!
    var viewModel: DessertListViewModel!

    override func setUpWithError() throws {
        apiService = MockMealAPIService()
        viewModel = DessertListViewModel(mealAPI: apiService)
    }

    override func tearDownWithError() throws {
        apiService = nil
        viewModel = nil
    }

    func testGetDessertMeals() async throws {
        // WHEN no replacementData set for mock
        await viewModel.getDessertMeals()
        // THEN viewModel's meals are still empty AND the errorMessage is still empty
        XCTAssert(viewModel.meals.isEmpty)
        XCTAssert(viewModel.errorMessage.isEmpty)
        
        apiService.replacementData = [Meal(id: "foo", name: "bar", thumbnailUrlString: "fizz.jpg"), Meal(id: "buzz", name: "abc", thumbnailUrlString: "def.jpg")]
        await viewModel.getDessertMeals()
        // WHEN the APIService returns Meals, THEN the viewModel uses the returned Meals to set its meals prop
        XCTAssert(viewModel.meals.count == 2)
        // AND the meals have been sorted by name, so ["abc, "bar"]
        XCTAssertEqual(viewModel.meals[0].name, "abc")
        XCTAssertEqual(viewModel.meals[1].name, "bar")
        XCTAssert(viewModel.errorMessage.isEmpty)
    }

    func testGetDessertMealsFailed() async throws {
        XCTAssert(viewModel.errorMessage.isEmpty) // Double check errorMessage starts empty

        apiService.error = MockError.someError
        // WHEN the APIService fails
        await viewModel.getDessertMeals()
        // THEN the viewModel will not set meals AND the errorMessage gets set, so it's no longer empty
        XCTAssert(viewModel.meals.isEmpty)
        XCTAssert(!viewModel.errorMessage.isEmpty)
        
        apiService.replacementData = [Meal(id: "foo", name: "bar", thumbnailUrlString: "fizz.jpg"), Meal(id: "buzz", name: "abc", thumbnailUrlString: "def.jpg")]
        // Even if the APIService had sent data, a thrown error prevents meals from being sent and an error message is set
        await viewModel.getDessertMeals()
        XCTAssert(viewModel.meals.isEmpty)
        // The following is the expected error message regardless of error caught at the moment
        XCTAssertEqual(viewModel.errorMessage, "Sorry seems we're having issues finding some good desserts!")
    }

}
