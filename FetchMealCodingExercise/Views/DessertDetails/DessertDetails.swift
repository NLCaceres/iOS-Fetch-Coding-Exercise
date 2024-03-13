//
//  DessertDetails.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/12/24.
//

import SwiftUI

struct DessertDetails: View {
    let id: String
    @StateObject var viewModel: DessertDetailsViewModel = DessertDetailsViewModel()

    var body: some View {
        List {
            DessertDetailsTitleSection(dessertMeal: viewModel.meal)

            if !viewModel.errorMessage.isEmpty {
                DessertDetailsErrorSection(errorMessage: viewModel.errorMessage)
            }
            
            if let ingredients = viewModel.meal?.ingredients {
                DessertDetailsIngredientSection(ingredients: ingredients)
            }
           
            if let instructions = viewModel.meal?.instructions {
                DessertDetailsInstructionSection(instructions: instructions)
            }
        }.task { await viewModel.getDessertMeal(byID: id) }
        .listStyle(.grouped)
    }
}

struct DessertDetails_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetails(id: "123")
        DessertDetails(id: "52899")
    }
}
