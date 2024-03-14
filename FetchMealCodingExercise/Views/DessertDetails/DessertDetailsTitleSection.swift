//
//  DessertDetailsTitleSection.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct DessertDetailsTitleSection: View {
    var dessertMeal: Meal? = nil

    var body: some View {
        Section {
            if let dessertMeal = dessertMeal {
                LabeledImage(label: dessertMeal.name, urlString: dessertMeal.thumbnailUrlString, imageSize: 100.0)
            }
            else {
                CenteredProgressView()
            }
        }
    }
}

struct DessertDetailsTitleSection_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetailsTitleSection()
        DessertDetailsTitleSection(
            dessertMeal: Meal(id: "123", name: "Cake", thumbnailUrlString: "https://www.themealdb.com/images/media/meals/vrspxv1511722107.jpg")
        )
    }
}
