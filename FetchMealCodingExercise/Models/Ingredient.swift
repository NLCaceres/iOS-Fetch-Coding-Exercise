//
//  Ingredient.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/7/24.
//

import Foundation

struct Ingredient: Encodable, Hashable {
    let name: String
    let measurement: String
    // The ingredient's number is important for identity, especially when a given ingredient may appear (or re-appear) in the instructions for a meal
    let number: Int // A lower number means it's likely an ingredient found earlier in the recipe instructions
    let readableStr: String
    
    init(name: String, measurement: String, number: Int) {
        self.name = name
        self.measurement = measurement
        self.number = number
        
        let capitalizedName = self.name.capitalized
        let lowercasedMeasurement = self.measurement.lowercased()

        // Measurements to suffix the Ingredient name
        let measurementSuffixes = ["for frying", "top", "topping", "to serve", "to glaze"]
        // Measurements that use "of"
        let measurementsWithOf = ["juice of", "pod of", "sprigs of", "zest of"]
        // Measurements to prefix the Ingredient name
        let measurementPrefixes = ["beaten", "chopped", "crushed", "free-range", "grated", "parts", "shredded", "whole", "small", "medium", "large"]
        // Check if measurement is just numbers
        let digitSet = CharacterSet(charactersIn: "0123456789")
        if (CharacterSet(charactersIn: measurement).isSubset(of: digitSet)) {
            self.readableStr = "\(measurement) \(capitalizedName)"
        }
        else if (measurementSuffixes.contains(where: lowercasedMeasurement.hasSuffix)) {
            // Example of the following: "Ice cream topping" or "Oil for frying"
            let formattedMeasurement = lowercasedMeasurement.hasSuffix("top") ? "topping" : lowercasedMeasurement
            self.readableStr = "\(capitalizedName) \(formattedMeasurement)"
        }
        else if (measurementsWithOf.contains(where: lowercasedMeasurement.contains)) {
            // Example of: "Juice of Orange" or "Sprigs of 2 Mint"
            let firstCharUppercaseMeasurement = lowercasedMeasurement.prefix(1).uppercased() + lowercasedMeasurement.dropFirst()
            self.readableStr = "\(firstCharUppercaseMeasurement) \(capitalizedName)"
        }
        else if (measurementPrefixes.contains(where: lowercasedMeasurement.contains)) {
            // Example of: "Chopped Onions" or "1 Small Egg"
            self.readableStr = "\(measurement.capitalized) \(capitalizedName)"
        }
        else if (lowercasedMeasurement.hasPrefix("garnish")) {
            // The one odd case that doesn't really fit in with any other
            self.readableStr = "Garnish with \(capitalizedName)"
        }
        else {
            // Otherwise, it's expected to receive a number with a measurement, like "123g", "1/2 cup"
            // OR a unit that uses "of" like "Pinch of"
            let startsWithNum = lowercasedMeasurement.first?.isNumber ?? false
            let correctCaseMeasurement = startsWithNum ? measurement.lowercased() : measurement.capitalized
            self.readableStr = "\(correctCaseMeasurement) of \(capitalizedName)"
        }
    }
}
