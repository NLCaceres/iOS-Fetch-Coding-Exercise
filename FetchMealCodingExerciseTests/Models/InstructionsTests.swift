//
//  InstructionsTests.swift
//  FetchMealCodingExerciseTests
//
//  Created by Nick Caceres on 3/7/24.
//

@testable import FetchMealCodingExercise
import XCTest

final class InstructionsTests: XCTestCase {

    func testStepByStepInstructionsInit() throws {
        let simpleFullInstructions = "Hello. World"
        let simpleInstructions = Instructions(fullInstructions: simpleFullInstructions)
        XCTAssertEqual(simpleInstructions.stepByStepInstructions, ["Hello", "World"])
        
        let normalFullInstructions = "Hello. World."
        let normalInstructions = Instructions(fullInstructions: normalFullInstructions)
        XCTAssertEqual(normalInstructions.stepByStepInstructions, ["Hello", "World"])
        
        // WHEN empty strings are found
        let emptyFullInstructions = ""
        let emptyInstructions = Instructions(fullInstructions: emptyFullInstructions)
        // THEN the property is an empty array
        XCTAssertEqual(emptyInstructions.stepByStepInstructions, [])
        
        // WHEN whitespace is found at the beginnings or ends of sentences
        let randomEmptySentenceInstruction = "Hello.        .       World."
        let randomEmptyInstructions = Instructions(fullInstructions: randomEmptySentenceInstruction)
        // THEN whitespace is removed
        XCTAssertEqual(randomEmptyInstructions.stepByStepInstructions, ["Hello", "World"])
        
        // WHEN no "." is found
        let singleInstruction = "Hello, World"
        let singleInstructions = Instructions(fullInstructions: singleInstruction)
        // THEN the whole phrase is taken as is
        XCTAssertEqual(singleInstructions.stepByStepInstructions, ["Hello, World"])
        
        // WHEN carraige returns or newlines are found at sentence ends or beginnings
        let instructionWithSpecialChars = "Hello \r\n. There. World."
        let specialInstructions = Instructions(fullInstructions: instructionWithSpecialChars)
        // THEN they are removed
        XCTAssertEqual(specialInstructions.stepByStepInstructions, ["Hello", "There", "World"])
        
        // WHEN other punctuation is used
        let instructionsWithSpecialCharsAndWhitespace = "Hello    . \r\n to the Whole! \r\n Wide world!! \r\n"
        let specialWhitespacedInstructions = Instructions(fullInstructions: instructionsWithSpecialCharsAndWhitespace )
        // THEN only carraige returns, newlines, and whitespace are trimmed from ends
        XCTAssertEqual(specialWhitespacedInstructions.stepByStepInstructions, ["Hello", "to the Whole! \r\n Wide world!!"])
    }
}
