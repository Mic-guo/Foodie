//
//  AuthViewModel.swift
//  Foodie
//
//  Created by Nandan Srikrishna on 2/17/24.
//

import SwiftUI
import Combine
import Supabase
import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthState()
    }

    func checkAuthState() {
        Task {
            do {
                // Asynchronously wait for the session to be fetched or refreshed
                let session = try await supabase.auth.session(from: URL(string: "https://homdedmzasjiinzfchqn.supabase.co")!)
                // Update the UI on the main thread
                await MainActor.run {
                    self.isAuthenticated = session != nil
                }
            } catch {
                print("Error checking authentication state: \(error)")
            }
        }
    }

    func signOut() {
        Task {
            do {
                try await supabase.auth.signOut()
                // Once logged out, update the authentication state on the main thread
                await MainActor.run {
                    self.isAuthenticated = false
                }
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
}


