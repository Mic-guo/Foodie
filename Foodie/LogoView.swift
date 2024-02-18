//
//  LogoView.swift
//  Foodie
//
//  Created by Nandan Srikrishna on 2/17/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 150, height: 50)
                .shadow(radius: 5)
            Text("Foodie")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
    }
}
