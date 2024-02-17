//
//  ContentView.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var isAuthenticated = false

      var body: some View {
        Group {
          if isAuthenticated {
            ProfileView()
          } else {
            AuthView()
          }
        }
        .task {
          for await state in await supabase.auth.authStateChanges {
            if [.initialSession, .signedIn, .signedOut].contains(state.event) {
              isAuthenticated = state.session != nil
            }
          }
        }
      }
}


#Preview {
    ContentView()
}
