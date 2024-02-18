//
//  ExploreView.swift
//  Foodie
//
//  Created by Nandan Srikrishna on 2/18/24.
//

import Foundation
import SwiftUI
import Supabase

struct ExploreView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                                .padding(.leading, 10)
                                .font(.system(size: 25))
                        }
//                        .background(.gray)
                        .foregroundColor(.white)
                    }
                    Spacer()
                    LogoView()
                    Spacer()
                    Image(systemName: "arrow.right")
                        .padding(.leading, 10)
                        .font(.system(size: 25))
                        .opacity(0)
                }
                .background(.gray)
                
                FriendsFeedView()
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
//        .background(.gray)
    }
}

#Preview {
    ExploreView()
}
