//
//  CenteredProgressView.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct CenteredProgressView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    // Color the ProgressView itself and its text for best visibility in both light and dark mode
    var viewColor: Color { return colorScheme == .light ? .black : .white }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView {
                    Text("Loading")
                        .font(.title3).foregroundColor(viewColor)
                }.frame(width: 100, height: 100).tint(viewColor)
                Spacer()
            }
            Spacer()
        }
    }
}

struct CenteredProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CenteredProgressView()
    }
}
