//
//  CenteredProgressView.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct CenteredProgressView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView {
                    Text("Loading").foregroundColor(.black).font(.title3)
                }.frame(width: 100, height: 100).tint(.black)
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
