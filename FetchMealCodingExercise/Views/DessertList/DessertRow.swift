//
//  DessertRow.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/10/24.
//

import SwiftUI

struct DessertRow: View {
    // Scaling based on larger Font.TextStyles reduces how much these change
    // Using .body would produce larger values at higher Dynamic Type sizes than .title or even .title3
    @ScaledMetric(relativeTo: .largeTitle) var textPadding = 15.0
    @ScaledMetric(relativeTo: .largeTitle) var imageSize = 70.0
    
    var dessertMeal: Meal

    var body: some View {
        NavigationLink(destination: {
            Text("Dessert Detail View")
        },
        label: {
            HStack {
                AsyncImage(url: URL(string: dessertMeal.thumbnailUrlString),
                    content: { image in image.resizable().aspectRatio(contentMode: .fill).cornerRadius(5) },
                    placeholder: { ProgressView() }
                ).frame(width: imageSize, height: imageSize)
                
                Text(dessertMeal.name).padding([.leading], textPadding).font(.title3).fontWeight(.medium)
            }
        })
    }
}

struct DessertRow_Previews: PreviewProvider {
    static var previews: some View {
        let dessert = Meal(id: "123", name: "Cake", thumbnailUrlString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        DessertRow(dessertMeal: dessert)
    }
}
