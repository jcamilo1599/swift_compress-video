//
//  LoadingView.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 7/07/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var loadingProgress: String?
    
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack(spacing: 0) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    if loadingProgress != nil {
                        Text(loadingProgress!)
                            .foregroundColor(.white)
                            .padding(.top, 14)
                    }
                }
            )
    }
}

#Preview {
    ZStack {
        LoadingView(loadingProgress: .constant("50.9%"))
    }
}
