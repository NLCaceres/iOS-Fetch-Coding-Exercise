//
//  DessertDetailsIngredientSection.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct DessertDetailsIngredientSection: View {
    let ingredients: [Ingredient]

    var body: some View {
        Section(content: {
            ForEach(ingredients, id: \.number) { ingredient in
                Text("- \(ingredient.readableStr)")
            } // The following alignment guide will not work with Inset-style Lists
            .alignmentGuide(.listRowSeparatorLeading) { dimensions in -dimensions.width / 2 }
        },
        header: {
            AppSectionHeader(title: "Ingredients")
        })
    }
}

struct DessertDetailsIngredientSection_Previews: PreviewProvider {
    static var previews: some View {
        let ingredients = [
            Ingredient(name: "Butter", measurement: "1 cup", number: 123),
            Ingredient(name: "Sugar", measurement: "1/2 cup", number: 321)
        ]
        List {
            DessertDetailsIngredientSection(ingredients: ingredients)
        }
    }
}
