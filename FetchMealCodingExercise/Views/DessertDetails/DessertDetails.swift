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
            Section {
                HStack {
                    if let dessertMeal = viewModel.meal {
                        AsyncImage(url: URL(string: dessertMeal.thumbnailUrlString),
                            content: { image in image.resizable().aspectRatio(contentMode: .fill).cornerRadius(5) },
                            placeholder: { ProgressView() }
                        ).frame(width: 100, height: 100)
                        
                        Text(dessertMeal.name).padding([.leading], 15).font(.title).fontWeight(.medium)
                    }
                    else {
                        Spacer()
                        ProgressView {
                            Text("Loading").foregroundColor(.black).font(.title3)
                        }.frame(width: 100, height: 100).tint(.black)
                        Spacer()
                    }
                }
            }
            
            if !viewModel.errorMessage.isEmpty {
                Section(content: {
                    HStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                            .foregroundStyle(.purple, .teal).font(.system(size: 42))
                        Text(viewModel.errorMessage)
                            .font(.title2)
                    }
                },
                header: {
                    HStack {
                        Text("Sorry!")
                            .font(.title).fontWeight(.bold).foregroundColor(.black)
                            .padding([.leading], 20)
                        Spacer()
                    }
                })
            }
            
            if let ingredients = viewModel.meal?.ingredients {
                Section(content: {
                    ForEach(Array(ingredients.enumerated()), id: \.0) { (index, ingredient) in
                        Text("\(index + 1). \(ingredient.name.capitalized) - \(ingredient.measurement)")
                    }.alignmentGuide(.listRowSeparatorLeading) { dimensions in -dimensions.width / 2 }
                },
                header: {
                    HStack {
                        Text("Ingredients")
                            .font(.title).fontWeight(.bold).foregroundColor(.black)
                            .padding([.leading], 20)
                        Spacer()
                    }
                })
            }
           
            if let instructions = viewModel.meal?.instructions?.stepByStepInstructions {
                Section(content: {
                    ForEach(Array(instructions.enumerated()), id: \.0) { (index, instruction) in
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
        }.task { await viewModel.getDessertMeal(byID: id) }
        .listStyle(.grouped)
    }
}

struct DessertDetails_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetails(id: "123")
    }
}
