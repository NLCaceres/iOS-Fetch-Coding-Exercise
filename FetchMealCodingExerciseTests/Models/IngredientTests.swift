//
//  IngredientTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/13/24.
//

@testable import FetchMealCodingExercise
import XCTest

final class IngredientTests: XCTestCase {
    func testDigitsMeasurement() {
        // WHEN the measurement is purely numerical
        let ingredient = Ingredient(name: "cherry", measurement: "4321", number: 123)
        // THEN the measurement is added in front of the name without making the name plural BUT the name is capitalized
        XCTAssertEqual(ingredient.readableStr, "4321 Cherry")
        
        // WHEN the measurement has spaces, commas, periods or other chars between the numbers
        // THEN the default readable measurement is used
        XCTAssertEqual(Ingredient(name: "foo bar", measurement: "123 456", number: 123).readableStr, "123 456 of Foo Bar")
        XCTAssertEqual(Ingredient(name: "fizz bUzz", measurement: "456,123", number: 123).readableStr, "456,123 of Fizz Buzz")
        XCTAssertEqual(Ingredient(name: "foo bizz", measurement: "654.321", number: 123).readableStr, "654.321 of Foo Bizz")
        
        // WHEN the measurement contains any letters at all
        let almostNumIngredient = Ingredient(name: "sugar", measurement: "123g", number: 123)
        // THEN the default readable measurement is used
        XCTAssertEqual(almostNumIngredient.readableStr, "123g of Sugar")
        
        // WHEN a unicode number is found
        let oddNumberIngredient = Ingredient(name: "Bar", measurement: "½", number: 123)
        // THEN the default readable measurement is used
        XCTAssertEqual(oddNumberIngredient.readableStr, "½ of Bar")
        
        // WHEN a typical fraction is found
        let normalNumberIngredient = Ingredient(name: "Bar", measurement: "1/2", number: 123)
        // THEN the default readable measurement is used
        XCTAssertEqual(normalNumberIngredient.readableStr, "1/2 of Bar")
    }

    func testSuffixedMeasurements() {
        // WHEN a certain set of measurement units are found in the Ingredient measurement as a SUFFIX, regardless of case
        let ingredient = Ingredient(name: "Lemon", measurement: "Some for frying", number: 123)
        // THEN the readable measurement places the capitalized name in front of a lowercased version of the measurement
        XCTAssertEqual(ingredient.readableStr, "Lemon some for frying")
        
        // WHEN the expected suffix is NOT the final part of the measurement string, THEN the default readable measurement is used
        XCTAssertEqual(Ingredient(name: "Cheese", measurement: "For Topping On", number: 123).readableStr, "For Topping On of Cheese")
        
        // WHEN the suffix is "top", regardless of case, THEN readable measurement is suffixed with "topping"
        XCTAssertEqual(Ingredient(name: "Butter", measurement: "ToP", number: 123).readableStr, "Butter topping")
    }

    func testMeasurementsWithOf() {
        // WHEN a certain set of measurements that use "of" in the middle are found, regardless of case
        let ingredient = Ingredient(name: "lemon", measurement: "jUiCe oF", number: 123)
        // THEN the measurement capitalizes the first letter only and is added IN FRONT OF the capitalized name
        XCTAssertEqual(ingredient.readableStr, "Juice of Lemon")
        
        // WHEN a measurement simply contains one of this set
        let containsOddMeasurementWithOf = Ingredient(name: "Cheese", measurement: "some Zest of this", number: 123)
        // THEN the measurement is added AS IS, with the first letter of the measurement capitalized, and the name normally capitalized
        XCTAssertEqual(containsOddMeasurementWithOf.readableStr, "Some zest of this Cheese")
        
        // WHEN a measurement has awkward phrasing but contains one of the set, THEN it will be awkwardly placed in front of the name
        XCTAssertEqual(Ingredient(name: "Basil", measurement: "22 SPRIGS OF THESE LITTLE", number: 123).readableStr, "22 sprigs of these little Basil")
    }

    func testPrefixedMeasurements() {
        // WHEN a certain set of measurement units are found in the Ingredient measurement, regardless of case
        let ingredient = Ingredient(name: "tree nuts", measurement: "CRUSHED", number: 123)
        // THEN the readable measurement is capitalized and added IN FRONT OF the capitalized name
        XCTAssertEqual(ingredient.readableStr, "Crushed Tree Nuts")
        
        // WHEN a measurement simply contains one of this set, THEN the measurement is added in front of the name AS IS (and still capitalized)
        XCTAssertEqual(Ingredient(name: "Cheese", measurement: "Quickly grated", number: 123).readableStr, "Quickly Grated Cheese")
        
        // WHEN a measurement has awkward phrasing but contains one of the set, THEN it will be awkwardly placed in front of the name
        XCTAssertEqual(Ingredient(name: "Cheese", measurement: "Chopped with", number: 123).readableStr, "Chopped With Cheese")
    }

    func testGarnishReadableMeasurement() {
        // WHEN "garnish" starts the measurement String
        let ingredient = Ingredient(name: "chili flakes", measurement: "Garnish", number: 123)
        // THEN the readable measurement starts with "Garnish with" followed by the capitalized name
        XCTAssertEqual(ingredient.readableStr, "Garnish with Chili Flakes")
        // REGARDLESS if there are words after "garnish"
        let ingredientWithGarnishPrefix = Ingredient(name: "Fruit", measurement: "Garnish with some", number: 123)
        XCTAssertEqual(ingredientWithGarnishPrefix.readableStr, "Garnish with Fruit")
        
        // WHEN "garnish" is randomly placed elsewhere
        let ingredientWithGarnishRandomly = Ingredient(name: "Lemon", measurement: "Some garnish", number: 123)
        // THEN the readable measurement falls to the default
        XCTAssertEqual(ingredientWithGarnishRandomly.readableStr, "Some Garnish of Lemon")
        
        let ingredientWithAwkwardGarnish = Ingredient(name: "Chili Powder", measurement: "Some garnish of", number: 123)
        XCTAssertEqual(ingredientWithAwkwardGarnish.readableStr, "Some Garnish Of of Chili Powder")
    }

    func testDefaultReadableMeasurement() throws {
        // WHEN a typical measurement is found with a number and unit
        let ingredient = Ingredient(name: "foo", measurement: "2 cups", number: 123)
        // THEN the lowercased measurement is placed in front of the capitalized name
        XCTAssertEqual(ingredient.readableStr, "2 cups of Foo")
        
        // WHEN a multi-word measurement is found
        let longIngredientName = Ingredient(name: "foo bar fizz buzz", measurement: "2 BLANKS", number: 123)
        // THEN the lowercased measurement is placed in front of the capitalized name
        XCTAssertEqual(longIngredientName.readableStr, "2 blanks of Foo Bar Fizz Buzz")
        
        // If an unknown measurement is found
        let oddIngredient = Ingredient(name: "Bar", measurement: "123 flowers", number: 123)
        // THEN it will default to this phrasing
        XCTAssertEqual(oddIngredient.readableStr, "123 flowers of Bar")
        
        // WHEN a multi-word measurement AND name is found
        let ingredientWithNonNumberUnit = Ingredient(name: "buzz fizz", measurement: "soMe bUnCHes", number: 123)
        // THEN all words except "of" are properly capitalized
        XCTAssertEqual(ingredientWithNonNumberUnit.readableStr, "Some Bunches of Buzz Fizz")
        
        // If an unknown measurement is found, BUT it doesn't start with numbers
        let oddIngredientWithoutNum = Ingredient(name: "Fizz", measurement: "squares", number: 123)
        // THEN the measurement is capitalized and concatenated to the name with "of"
        XCTAssertEqual(oddIngredientWithoutNum.readableStr, "Squares of Fizz")
        
        // If an unknown measurement is found that contains a number in the middle of it
        let oddIngredientWithRandomNum = Ingredient(name: "Buzz", measurement: "Spoons, 2", number: 123)
        // THEN it is capitalized and awkwardly concatenated with "of"
        XCTAssertEqual(oddIngredientWithRandomNum.readableStr, "Spoons, 2 of Buzz")
    }
}
