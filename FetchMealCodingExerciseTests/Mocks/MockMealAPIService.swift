//
//  MockMealAPIService.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/10/24.
//

@testable import FetchMealCodingExercise
import Foundation

class MockMealAPIService: MealApiService {
    var replacementData: [Meal] = []
    var error: Error? = nil
    
    func getMealListFiltered(byCategory category: String) async throws -> [Meal] {
        if let error = error {
            throw error
        }
        return replacementData
    }
    
    func getMeal(byID id: String) async throws -> Meal? {
        if let error = error {
            throw error
        }
        return replacementData.count > 0 ? replacementData[0] : nil
    }
}
