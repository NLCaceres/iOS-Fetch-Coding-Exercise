//
//  Meal.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/7/24.
//

import Foundation

struct Meal: Encodable {
    var id: String
    var name: String
    var thumbnailUrlString: String
    var ingredients: [Ingredient]?
    var instructions: Instructions?
}
