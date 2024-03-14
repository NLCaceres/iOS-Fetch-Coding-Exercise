//
//  AppSectionHeader.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

/// Used as an app-wide List Section header, accepting a Section title String
/// Responds to dark mode changing its font color between black and white as needed
struct AppSectionHeader: View {
    let title: String
    
    var textPadding = EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0)
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        HStack {
            Text(title)
                .font(.title).fontWeight(.bold).foregroundColor(colorScheme == .light ? .black : .white)
                .padding(textPadding)
            Spacer()
        }
    }
}

struct AppSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        AppSectionHeader(title: "Hello World!")
    }
}
