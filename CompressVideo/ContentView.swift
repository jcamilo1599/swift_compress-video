//
//  ContentView.swift
//  CompressVideo
//
//  Created by Juan Camilo Marín Ochoa on 27/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = false
    @State private var loadingProgress: String?
    
    var body: some View {
        ZStack {
            NavigationView {
                HomeView(isLoading: $isLoading, loadingProgress: $loadingProgress)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.orange)
            .blur(radius: isLoading ? 3 : 0)
            
            if isLoading {
                LoadingView(loadingProgress: $loadingProgress)
            }
        }
    }
}

#Preview {
    ContentView()
}
