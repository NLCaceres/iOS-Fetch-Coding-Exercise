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
        
        let emptyFullInstructions = ""
        let emptyInstructions = Instructions(fullInstructions: emptyFullInstructions)
        XCTAssertEqual(emptyInstructions.stepByStepInstructions, [])
        
        let randomEmptySentenceInstruction = "Hello.        .       World."
        let randomEmptyInstructions = Instructions(fullInstructions: randomEmptySentenceInstruction)
        XCTAssertEqual(randomEmptyInstructions.stepByStepInstructions, ["Hello", "World"])
        
        let singleInstruction = "Hello, World"
        let singleInstructions = Instructions(fullInstructions: singleInstruction)
        XCTAssertEqual(singleInstructions.stepByStepInstructions, ["Hello, World"])
        
        let instructionWithSpecialChars = "Hello \r\n. There. World."
        let specialInstructions = Instructions(fullInstructions: instructionWithSpecialChars)
        XCTAssertEqual(specialInstructions.stepByStepInstructions, ["Hello \r\n", "There", "World"])
    }
}
