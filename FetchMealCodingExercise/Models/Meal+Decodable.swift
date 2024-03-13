//
//  Meal+Decodable.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/8/24.
//

import Foundation

extension Meal: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailUrlString = "strMealThumb"
        case instructions = "strInstructions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try values.decode(String.self, forKey: .id)
        let name = try values.decode(String.self, forKey: .name)
        let thumbnailUrlString = try values.decode(String.self, forKey: .thumbnailUrlString)
        self.init(id: id, name: name, thumbnailUrlString: thumbnailUrlString)

        // Check if instruction key present, fill prop if instructions key found with a String value
        let fullInstructions = try values.decodeIfPresent(String.self, forKey: .instructions)
        if let fullInstructions = fullInstructions {
            self.instructions = Instructions(fullInstructions: fullInstructions)
        }

        // Ingredients info divided into keys prefixed by either "strIngredient" or "strMeasure" followed by a num
        let fullValues = try decoder.container(keyedBy: JsonCodingKey.self)
        // The keys are numbered starting from 1 and seem to stop at 20. Not all 20 keys are used though so the last few will be empty or nil
        var ingredientNames: [String] = []
        var ingredientNum = 1
        var jsonCodingKey = JsonCodingKey(stringValue: "strIngredient\(ingredientNum)")
        // Since it's not perfectly clear whether the max number of ingredient info keys is 20, run a while loop until I run out of matching keys
        while fullValues.contains(jsonCodingKey) {
            let ingredientName = try fullValues.decodeIfPresent(String.self, forKey: jsonCodingKey) ?? ""
            // Once I reach the last few keys, I should start to get empty strings or null
            // which SHOULD mean I can break the loop since I have all the ingredient info
            if ingredientName.trimmingCharacters(in: .whitespaces).isEmpty { break }

            ingredientNames.append(ingredientName)
            
            ingredientNum += 1
            jsonCodingKey = JsonCodingKey(stringValue: "strIngredient\(ingredientNum)")
        }
        
        // Similar to the ingredient name loop above, loop through the "strMeasure\(num)" keys until we run out of keys OR values become "" or nil
        // QUESTION: Can I assume that there are ALWAYS 20 ingredient names to match with 20 measurements?
        // BECAUSE then I can merge the loops, saving one extra loop
        var ingredientArray: [Ingredient] = []
        ingredientNum = 1
        jsonCodingKey = JsonCodingKey(stringValue: "strMeasure\(ingredientNum)")
        while fullValues.contains(jsonCodingKey) {
            let ingredientMeasurement = try fullValues.decodeIfPresent(String.self, forKey: jsonCodingKey) ?? ""
            // By trimming whitespace can also avoid blank strings like "    "
            if ingredientMeasurement.trimmingCharacters(in: .whitespaces).isEmpty { break }

            ingredientArray.append(Ingredient(name: ingredientNames[ingredientNum - 1], measurement: ingredientMeasurement))
            
            ingredientNum += 1
            jsonCodingKey = JsonCodingKey(stringValue: "strMeasure\(ingredientNum)")
        }
        if !ingredientArray.isEmpty {
            self.ingredients = ingredientArray
        }
    }
}
