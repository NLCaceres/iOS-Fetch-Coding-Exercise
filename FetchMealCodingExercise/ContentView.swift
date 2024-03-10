//
//  ContentView.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            DessertList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
