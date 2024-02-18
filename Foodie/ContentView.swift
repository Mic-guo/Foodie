//
//  ContentView.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
//        if !authViewModel.isAuthenticated {
//            LandingView()
//        } else {
//            HomeView()
//        }
        Text("Useless ahhh page")
    }
}


#Preview {
    ContentView()
}
