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
    
    // Alerta que informa el estado de la conversión
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertDescription = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                HomeView(
                    isLoading: $isLoading,
                    loadingProgress: $loadingProgress,
                    showAlert: $showAlert,
                    alertTitle: $alertTitle,
                    alertDescription: $alertDescription
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.orange)
            .blur(radius: isLoading ? 3 : 0)
            
            if isLoading {
                LoadingView(loadingProgress: $loadingProgress)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString(alertTitle, comment: "")),
                message: Text(NSLocalizedString(alertDescription, comment: "")),
                dismissButton: .default(Text("close"))
            )
        }
    }
}

#Preview {
    ContentView()
}
