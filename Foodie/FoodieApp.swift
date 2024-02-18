//
//  FoodieApp.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI

@main
struct FoodieApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
//            if !authViewModel.isAuthenticated {
//                LandingView().environmentObject(authViewModel)
//            } else {
                HomeView().environmentObject(authViewModel)
//            }
        }
    }
}
