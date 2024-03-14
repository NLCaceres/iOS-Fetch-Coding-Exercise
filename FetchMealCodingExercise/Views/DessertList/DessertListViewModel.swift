//
//  DessertListViewModel.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/10/24.
//

import Foundation

class DessertListViewModel: ObservableObject {
    let mealAPI: MealApiService

    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var meals: [Meal] = []
    
    init(mealAPI: MealApiService = AppMealApiService()) {
        self.mealAPI = mealAPI
    }
    
    // MainActor ensures publishing occurs on the Main thread while the network request occurs in the background
    @MainActor
    func getDessertMeals() async {
        isLoading = true
        defer { isLoading = false } // Runs no matter what (similar to a Java finally block)

        errorMessage = ""

        do {
            meals = try await mealAPI.getMealListFiltered(byCategory: "Dessert").sorted {
                // Sorted by name alphabetically a-Z
                $0.name.lowercased() < $1.name.lowercased()
            }
        }
        catch {
            errorMessage = "Sorry seems we're having issues finding some good desserts!"
        }
    }
}
