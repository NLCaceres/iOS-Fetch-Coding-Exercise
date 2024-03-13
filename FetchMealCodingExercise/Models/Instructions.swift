//
//  Instructions.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/7/24.
//

import Foundation

struct Instructions: Encodable {
    let fullInstructions: String
    let stepByStepInstructions: [String]
    
    init(fullInstructions: String) {
        self.fullInstructions = fullInstructions

        // Remove Carraige Returns, Newlines and whitespace from Step by Step instructions
        var trimmableChars = CharacterSet()
        trimmableChars.formUnion(.whitespaces)
        trimmableChars.insert(charactersIn: "\n\r")
        self.stepByStepInstructions = fullInstructions.components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: trimmableChars) }
            .filter { !$0.isEmpty } // ONLY include strings that are NOT empty
    }
}
