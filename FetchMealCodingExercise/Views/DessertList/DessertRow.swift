//
//  DessertRow.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/10/24.
//

import SwiftUI

struct DessertRow: View {
    @ScaledMetric(relativeTo: .title3) var textPadding = 15

    var body: some View {
        NavigationLink(destination: {
            Text("Dessert Detail View")
        },
        label: {
            HStack {
                AsyncImage(url: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"),
                    content: { image in image.resizable().aspectRatio(contentMode: .fill).cornerRadius(5) },
                    placeholder: { ProgressView() }
                ).frame(width: 70, height: 70)
                
                Text("Meal Name").padding([.leading], textPadding).font(.title3).fontWeight(.medium)
            }
        })
    }
}

struct DessertRow_Previews: PreviewProvider {
    static var previews: some View {
        DessertRow()
    }
}
