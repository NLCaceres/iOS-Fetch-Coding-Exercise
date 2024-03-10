//
//  DessertList.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/9/24.
//

import SwiftUI

struct DessertList: View {
    @ScaledMetric(relativeTo: .title3) var textPadding = 15

    var body: some View {
        List {
            Section(content: {
                ForEach(0..<5) { _ in
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
                    
                }.alignmentGuide(.listRowSeparatorLeading) { dimensions in 0 }
            },
            header: {
                HStack {
                    Text("Desserts")
                        .font(.title).fontWeight(.bold).foregroundColor(.black)
                        .padding([.leading], 20)
                    Spacer()
                }
            })
        }
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
