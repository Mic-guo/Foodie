//
//  LandingView.swift
//  Foodie
//
//  Created by Nandan Srikrishna on 2/17/24.
//

import SwiftUI
import CoreData

struct LandingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                LogoView()
                
                Spacer()
                
                VStack {
                    NavigationButtonView(label: Text("Sign Up"), destination: AnyView(SignUpView().environmentObject(authViewModel)))
                        .frame(width: 350)
                    NavigationButtonView(label: Text("Sign In"), destination: AnyView(SignInView()))
                        .frame(width: 350)
                }
                Spacer()
            }
        }
    }
}


#Preview {
    LandingView().environmentObject(AuthViewModel())
}
