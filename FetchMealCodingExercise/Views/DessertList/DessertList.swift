//
//  DessertList.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/9/24.
//

import SwiftUI

struct DessertList: View {
    var body: some View {
        List {
            Section(content: {
                ForEach(0..<5) { _ in
                    DessertRow()
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
