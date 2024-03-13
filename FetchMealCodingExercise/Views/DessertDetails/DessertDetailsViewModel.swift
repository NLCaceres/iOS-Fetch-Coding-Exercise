//
//  DessertDetailsViewModel.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

class DessertDetailsViewModel: ObservableObject {
    let mealAPI: MealApiService
    
    @Published private(set) var errorMessage = ""
    @Published private(set) var meal: Meal? = nil
    
    init(mealAPI: MealApiService = AppMealApiService()) {
        self.mealAPI = mealAPI
    }
    
    @MainActor
    func getDessertMeal(byID id: String) async {
        errorMessage = ""
        do {
            meal = try await mealAPI.getMeal(byID: id)
        }
        catch {
            errorMessage = "We seem to be having issues finding your dessert!"
        }
    }
}
