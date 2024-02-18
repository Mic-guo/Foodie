//
//  NavigationButtonView.swift
//  Foodie
//
//  Created by Nandan Srikrishna on 2/17/24.
//

import SwiftUI

struct NavigationButtonView<Content: View>: View {
    var label: Content
    var destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            label
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(15)
                .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 10)
                .padding(.horizontal, 10)
        }
    }
}
