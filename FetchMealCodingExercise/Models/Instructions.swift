//
//  Instructions.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/7/24.
//

import Foundation

struct Instructions {
    let fullInstructions: String
    let stepByStepInstructions: [String]
    
    init(fullInstructions: String) {
        self.fullInstructions = fullInstructions
        self.stepByStepInstructions = fullInstructions.components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty } // ONLY include strings that are NOT empty
    }
}
