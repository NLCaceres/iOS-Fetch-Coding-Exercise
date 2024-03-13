//
//  LabeledImage.swift
//  FetchMealCodingExercise
//
//  Created by Nick Caceres on 3/13/24.
//

import SwiftUI

struct LabeledImage: View {
    let label: String
    let urlString: String
    
    // Scaling based on larger Font.TextStyles reduces how much these change
    // Using .body would produce larger values at higher Dynamic Type sizes than .title or even .title3
    @ScaledMetric(relativeTo: .largeTitle) var textPadding = 15.0
    @ScaledMetric(relativeTo: .largeTitle) var imageSize = 70.0
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: urlString),
                       content: { image in image.resizable().aspectRatio(contentMode: .fill).cornerRadius(5) },
                       placeholder: { ProgressView() }
            ).frame(width: imageSize, height: imageSize)
            
            Text(label).padding([.leading], textPadding).font(.title3).fontWeight(.medium)
        }
    }
}
