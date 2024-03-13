//
//  AppSectionHeader.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct AppSectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.title).fontWeight(.bold).foregroundColor(.black)
                .padding([.leading], 20)
            Spacer()
        }
    }
}

struct AppSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        AppSectionHeader(title: "Hello World!")
    }
}
