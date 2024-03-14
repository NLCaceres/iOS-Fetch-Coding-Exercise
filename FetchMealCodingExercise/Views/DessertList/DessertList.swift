//
//  DessertList.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/9/24.
//

import SwiftUI

struct DessertList: View {
    @StateObject private var viewModel = DessertListViewModel()
    
    var body: some View {
        List {
            Section(content: {
                ForEach(viewModel.meals) { meal in
                    DessertRow(dessertMeal: meal)
                }.alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            },
            header: {
                AppSectionHeader(title: "Desserts")
            })
        }
        .listStyle(.plain)
        .overlay { viewModel.isLoading ? CenteredProgressView() : nil }
        .overlay { viewModel.errorMessage.isEmpty ? nil : DessertListErrorSection(errorMessage: viewModel.errorMessage) }
        .task { await viewModel.getDessertMeals() }
        .refreshable { await viewModel.getDessertMeals() }
        .navigationTitle("Meals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        DessertList()
    }
}
