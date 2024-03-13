//
//  DessertDetails.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/12/24.
//

import SwiftUI

struct DessertDetails: View {
    var dessertMeal = Meal(
        id: "52767", name: "Bakewell Tart",
        thumbnailUrlString:"https://www.themealdb.com/images/media/meals/wyrqqq1468233628.jpg",
        ingredients: [
            Ingredient(name: "plain flour", measurement: "175g / 6oz"), Ingredient(name: "chilled butter", measurement: "75g / 2½oz")
        ],
        instructions: Instructions(fullInstructions: """
            To make the pastry, measure the flour into a bowl and rub in the butter with your fingertips until the mixture \
            resembles fine breadcrumbs. Add the water, mixing to form a soft dough.\r\nRoll out the dough on a lightly floured \
            work surface and use to line a 20cm/8in flan tin. Leave in the fridge to chill for 30 minutes.\r\nPreheat the oven \
            to 200C/400F/Gas 6 (180C fan).\r\nLine the pastry case with foil and fill with baking beans. Bake blind for about \
            15 minutes, then remove the beans and foil and cook for a further five minutes to dry out the base.\r\nFor the \
            filing, spread the base of the flan generously with raspberry jam.\r\nMelt the butter in a pan, take off the heat \
            and then stir in the sugar. Add ground almonds, egg and almond extract. Pour into the flan tin and sprinkle over \
            the flaked almonds.\r\nBake for about 35 minutes. If the almonds seem to be browning too quickly, cover the tart \
            loosely with foil to prevent them burning.
            """
        )
    )
    var body: some View {
        List {
            Section {
                HStack {
                    AsyncImage(url: URL(string: dessertMeal.thumbnailUrlString),
                        content: { image in image.resizable().aspectRatio(contentMode: .fill).cornerRadius(5) },
                        placeholder: { ProgressView() }
                    ).frame(width: 100, height: 100)
                    
                    Text(dessertMeal.name).padding([.leading], 15).font(.title).fontWeight(.medium)
                }
            }

            Section(content: {
                let ingredients = dessertMeal.ingredients ?? []
                ForEach(Array(ingredients.enumerated()), id: \.0) { (index, ingredient) in
                    Text("\(index + 1). \(ingredient.name) - \(ingredient.measurement)")
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

            Section(content: {
                let instructions = dessertMeal.instructions?.stepByStepInstructions ?? []
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
        }.listStyle(.grouped)
    }
}

struct DessertDetails_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetails()
    }
}
