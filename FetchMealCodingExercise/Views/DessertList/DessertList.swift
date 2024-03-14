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
                if (viewModel.meals.isEmpty || viewModel.isLoading || !viewModel.errorMessage.isEmpty) {
                    // Adding an empty row ensures consistent styling with plain lists
                    // In particular, no color changes or major jumps seem to happen
                    HStack {}.frame(height: 0).listRowSeparator(.hidden, edges: .bottom)
                }
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
        .task { if viewModel.initialLoad { await viewModel.getDessertMeals() } }
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
