//
//  DessertDetailsViewModelTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/13/24.
//

@testable import FetchMealCodingExercise
import XCTest

final class DessertDetailsViewModelTests: XCTestCase {
    var apiService: MockMealAPIService!
    var viewModel: DessertDetailsViewModel!

    override func setUpWithError() throws {
        apiService = MockMealAPIService()
        viewModel = DessertDetailsViewModel(mealAPI: apiService)
    }

    override func tearDownWithError() throws {
        apiService = nil
        viewModel = nil
    }

    func testGetDessertMeal() async throws {
        // WHEN no replacementData set for mock
        await viewModel.getDessertMeal(byID: "123")
        // THEN viewModel's meal is still nil AND the errorMessage is still empty
        XCTAssertNil(viewModel.meal)
        XCTAssert(viewModel.errorMessage.isEmpty)
        
        apiService.replacementData = [Meal(id: "foo", name: "bar", thumbnailUrlString: "fizz.jpg")]
        await viewModel.getDessertMeal(byID: "123")
        // WHEN the APIService returns a Meal, THEN the viewModel uses that meal to set its prop
        XCTAssertEqual(viewModel.meal!.id, "foo")
        XCTAssertEqual(viewModel.meal!.name, "bar")
        XCTAssert(viewModel.errorMessage.isEmpty)
    }

    func testGetDessertMealFailed() async throws {
        XCTAssert(viewModel.errorMessage.isEmpty) // Double check errorMessage starts empty

        apiService.error = MockError.someError
        // WHEN the APIService fails
        await viewModel.getDessertMeal(byID: "123")
        // THEN the viewModel will not set the meal prop AND the errorMessage gets set, so it's no longer empty
        XCTAssertNil(viewModel.meal)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
        
        apiService.replacementData = [Meal(id: "foo", name: "bar", thumbnailUrlString: "fizz.jpg")]
        // Even if the APIService had sent data, a thrown error prevents meal from being set and an error message is set
        await viewModel.getDessertMeal(byID: "123")
        XCTAssertNil(viewModel.meal)
        // The following is the expected error message regardless of error caught at the moment
        XCTAssertEqual(viewModel.errorMessage, "We seem to be having issues finding your dessert!")
    }

}
