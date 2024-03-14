//
//  DessertListViewModelTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/10/24.
//

@testable import FetchMealCodingExercise
import XCTest
import Combine

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
        XCTAssertFalse(viewModel.isLoading) // Double check isLoading starts as false
        // WHEN no replacementData set for mock
        await viewModel.getDessertMeals()
        // THEN viewModel's meals are still empty AND the errorMessage is still empty AND isLoading = false again
        XCTAssert(viewModel.meals.isEmpty)
        XCTAssert(viewModel.errorMessage.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        
        apiService.replacementData = [Meal(id: "foo", name: "bar", thumbnailUrlString: "fizz.jpg"), Meal(id: "buzz", name: "abc", thumbnailUrlString: "def.jpg")]
        await viewModel.getDessertMeals()
        // WHEN the APIService returns Meals, THEN the viewModel uses the returned Meals to set its meals prop
        XCTAssert(viewModel.meals.count == 2)
        // AND the meals have been sorted by name, so ["abc, "bar"]
        XCTAssertEqual(viewModel.meals[0].name, "abc")
        XCTAssertEqual(viewModel.meals[1].name, "bar")
        XCTAssert(viewModel.errorMessage.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testGetDessertMealsFailed() async throws {
        XCTAssert(viewModel.errorMessage.isEmpty) // Double check errorMessage starts empty
        XCTAssertFalse(viewModel.isLoading) // Also double check isLoading is false

        apiService.error = MockError.someError
        // WHEN the APIService fails
        await viewModel.getDessertMeals()
        // THEN the viewModel will not set meals AND the errorMessage gets set, so it's no longer empty
        XCTAssert(viewModel.meals.isEmpty)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
        // AND isLoading is false despite the function throwing
        XCTAssertFalse(viewModel.isLoading)
        
        apiService.replacementData = [Meal(id: "foo", name: "bar", thumbnailUrlString: "fizz.jpg"), Meal(id: "buzz", name: "abc", thumbnailUrlString: "def.jpg")]
        // Even if the APIService had sent data, a thrown error prevents meals from being sent and an error message is set
        await viewModel.getDessertMeals()
        XCTAssert(viewModel.meals.isEmpty)
        // The following is the expected error message regardless of error caught at the moment
        XCTAssertEqual(viewModel.errorMessage, "Sorry seems we're having issues finding some good desserts!")
    }

    func testLoadingProgression() async throws {
        // SETUP
        var cancellables = Set<AnyCancellable>()
        var loadingChanged = 0
        
        // EXPECTATIONS
        let initialCallExpectation = self.expectation(description: "isLoading is received 3 times")
        // XCTestExpectations made using this XCTestCase's convenience method ensures they are fulfilled ONLY ONCE, asserting if exceeded
        let errorExpectation = self.expectation(description: "isLoading is received 5 total times despite error")
        XCTAssertFalse(viewModel.isLoading) // Starts false
        viewModel.$isLoading.sink {
            loadingChanged % 2 == 0 ? XCTAssertFalse($0) : XCTAssertTrue($0)
            loadingChanged += 1
            print(loadingChanged)
            if (loadingChanged == 3) { initialCallExpectation.fulfill() }
            if (loadingChanged == 5) { errorExpectation.fulfill() }
        }.store(in: &cancellables)
        
        // WHEN the APIService is called, THEN isLoading changes twice, so 3 values are received by the publisher --False--True--False-->
        await viewModel.getDessertMeals()
        XCTAssertFalse(viewModel.isLoading)

        apiService.error = MockError.someError
        // WHEN the APIService is called BUT fails, THEN 2 more values are still received --True--False-->
        await viewModel.getDessertMeals()
        // even though the catch block ran and set the errorMessage property
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    
        wait(for: [initialCallExpectation, errorExpectation], timeout: 2)
    }
}
