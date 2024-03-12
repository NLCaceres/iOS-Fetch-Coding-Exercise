//
//  MealAPIService.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/8/24.
//

import Foundation

protocol MealApiService {
    func getMealListFiltered(byCategory category: String) async throws -> [Meal]
    func getMeal(byID id: String) async throws -> Meal?
}

struct AppMealApiService: MealApiService {
    let networkManager: NetworkManager
    init(networkManager: NetworkManager = AppNetworkManager()) {
        self.networkManager = networkManager
    }
    
    /// Fetches an Array of Meals from the "/filter" endpoint of the Meal DB Rest API
    /// Appends a Category query parameter used to determine what type of Meals are included in the Array
    func getMealListFiltered(byCategory category: String) async throws -> [Meal] {
        let categoryQuery = URLQueryItem(name: "c", value: category)
        
        let result = await networkManager.fetchDataWithQueries(endpointPath: "/filter.php", queryParams: [categoryQuery])
        
        let data = try result.get()

        let decoder = JSONDecoder()
        let mealsDict = try decoder.decode([String : [Meal]].self, from: data)

        let meals = mealsDict["meals", default: []]
        return meals
    }
    
    /// Fetches a Meal from the "/lookup" endpoint of the Meal DB Rest API
    /// Appends an "i" query param used to find a single Meal based on ID. Although a single Meal is returned, the REST API sends a Meal Array with a single Meal
    func getMeal(byID id: String) async throws -> Meal? {
        let idQuery = URLQueryItem(name: "i", value: id)
        
        let result = await networkManager.fetchDataWithQueries(endpointPath: "/lookup.php", queryParams: [idQuery])
        
        let data = try result.get()

        let decoder = JSONDecoder()
        let mealsDict = try decoder.decode([String : [Meal]].self, from: data)

        let meals = mealsDict["meals", default: []]
        return meals.count == 0 ? nil : meals[0]
    }
}
