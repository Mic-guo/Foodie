//
//  InverseMask.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import Foundation
import SwiftUI

extension View {
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        // This view is the original content
        self
            // Apply a mask that combines the original mask view
            .mask(
                ZStack {
                    // The masking view, where the mask's opaque areas are clear and the transparent areas are opaque
                    self
                        // Render the content and the mask as a single bitmap image
                        .compositingGroup()
                        // Use the destination out blend mode to subtract the mask from the view
                        .blendMode(.destinationOut)
                        // Overlay the mask view on top
                        .overlay(mask)
                }
            )
    }
}
