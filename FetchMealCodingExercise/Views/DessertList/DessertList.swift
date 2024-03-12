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
                HStack {
                    Text("Desserts")
                        .font(.title).fontWeight(.bold).foregroundColor(.black)
                        .padding([.leading], 20)
                    Spacer()
                }
            })
        }.task { await viewModel.getDessertMeals() }
        .listStyle(.plain)
        .navigationTitle("Meals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DessertList_Previews: PreviewProvider {
    static var previews: some View {
        DessertList()
    }
}
