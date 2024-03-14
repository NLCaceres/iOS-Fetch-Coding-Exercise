//
//  DessertListErrorSection.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/14/24.
//

import SwiftUI

/// A view for displaying any errors caught when fetching the List of Desserts Meals
/// Laid out to resemble the List's sections while placed via overlay() with a system gray bottom half and a clear top half to prevent obscuring any title text
/// Makes use of Geometry reader to offset the VStack main view from the device's true vertical + horizontal center by using Colors as Spacers thanks to their adjustable frame
struct DessertListErrorSection: View {
    var errorMessage: String
    
    @ScaledMetric(relativeTo: .largeTitle) var foodIconSize = 35

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Color.clear.frame(height: geometry.size.height * 0.25)
                AppSectionHeader(
                    title: "SORRY!",
                    textPadding: .init(top: 25.0, leading: 20.0, bottom: 0.0, trailing: 0.0)
                ).frame(height: 80).background(Color(UIColor.systemGroupedBackground))
                HStack {
                    Spacer()
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .foregroundStyle(.purple, .teal).font(.system(size: foodIconSize))
                    Text(errorMessage)
                        .font(.title2)
                    Spacer()
                }.padding([.all], 20).background(.white)
                Color(UIColor.systemGroupedBackground)
            }
        }
    }
}

struct DessertListErrorSection_Previews: PreviewProvider {
    static var previews: some View {
        DessertListErrorSection(errorMessage: "We seem to be having issues finding some good desserts!")
    }
}
