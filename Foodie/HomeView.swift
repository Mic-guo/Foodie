//
//  Home.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI

struct HomeView: View {
    init() {
        UINavigationBar.applyCustomAppearance()
    }
    var body: some View {
//        PermissionsView()
        CameraView()
    }
}

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    HomeView()
}

