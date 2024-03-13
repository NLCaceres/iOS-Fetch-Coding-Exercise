//
//  DessertDetailsErrorSection.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct DessertDetailsErrorSection: View {
    var errorMessage: String
    
    @ScaledMetric(relativeTo: .largeTitle) var foodIconSize = 35

    var body: some View {
        Section(content: {
            HStack {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .foregroundStyle(.purple, .teal).font(.system(size: foodIconSize))
                Text(errorMessage)
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
}

struct DessertDetailsErrorSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DessertDetailsErrorSection(errorMessage: "Something's wrong!")
        }
    }
}
