//
//  AuthView.swift
//  Foodie
//
//  Created by Michael Xcode on 2/17/24.
//

import SwiftUI
import Supabase

struct SignInView: View {
    @State var email = ""
    @State var password = "" // Add a state variable for the password
    @State var isLoading = false
    @State var result: Result<Void, Error>?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password) // Add a SecureField for password input
                        .textContentType(.password)
                }

                Section {
                    Button("Sign in") {
                        signInButtonTapped()
                    }
                    .disabled(email.isEmpty || password.isEmpty) // Disable the button if email or password is empty

                    if isLoading {
                        ProgressView()
                    }
                }

                if let result {
                    Section {
                        switch result {
                        case .success:
                            Text("Login successful.").foregroundStyle(.green)
                            
                        case .failure(let error):
                            Text(error.localizedDescription).foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Sign In", displayMode: .inline)
        }
    }
    

    func signInButtonTapped() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                // Use signIn with email and password
                _ = try await supabase.auth.signIn(email: email, password: password)
                result = .success(())
                DispatchQueue.main.async {
                    authViewModel.isAuthenticated = true
                }
            } catch {
                result = .failure(error)
            }
        }
    }
}

#Preview {
    SignInView()
}
