//
//  DessertRow.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/10/24.
//

import SwiftUI

struct DessertRow: View {
    var dessertMeal: Meal

    var body: some View {
        NavigationLink(destination: {
            DessertDetails(id: dessertMeal.id)
        },
        label: {
            LabeledImage(label: dessertMeal.name, urlString: dessertMeal.thumbnailUrlString)
        })
    }
}

struct DessertRow_Previews: PreviewProvider {
    static var previews: some View {
        let dessert = Meal(id: "123", name: "Cake", thumbnailUrlString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        DessertRow(dessertMeal: dessert)
    }
}
