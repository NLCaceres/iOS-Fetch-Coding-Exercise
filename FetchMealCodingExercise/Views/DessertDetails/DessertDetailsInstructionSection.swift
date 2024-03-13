//
//  DessertDetailsInstructionSection.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct DessertDetailsInstructionSection: View {
    let instructions: Instructions
    
    var body: some View {
        Section(content: {
            ForEach(Array(instructions.stepByStepInstructions.enumerated()), id: \.0) { (index, instruction) in
                Text("\(index + 1). \(instruction)")
            }.alignmentGuide(.listRowSeparatorLeading) { dimensions in -dimensions.width / 2 }
        },
        header: {
            HStack {
                Text("Instructions")
                    .font(.title).fontWeight(.bold).foregroundColor(.black)
                    .padding([.leading], 20)
                Spacer()
            }
        })
    }
}

struct DessertDetailsInstructionSection_Previews: PreviewProvider {
    static var previews: some View {
        let instructions = Instructions(fullInstructions: """
        Put the flour, eggs, milk, 1 tbsp oil and a pinch of salt into a bowl or large jug, then whisk to a smooth batter. \
        Set aside for 30 mins to rest if you have time, or start cooking straight away.\r\nSet a medium frying pan or crêpe \
        pan over a medium heat and carefully wipe it with some oiled kitchen paper. When hot, cook your pancakes for 1 min on \
        each siduntil golden, keeping them warm in a low oven as you go.\r\nServe with lemon wedges and sugar, or your favourite \
        filling. Once cold, you can layer the pancakes between baking parchment, then wrap in cling film and freeze for up to 2 months.
        """)
        List {
            DessertDetailsInstructionSection(instructions: instructions)
        }
    }
}
