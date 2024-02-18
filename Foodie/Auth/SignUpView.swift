//
//  SignUpView.swift
//  Foodie
//
//  Created by Nandan Srikrishna on 2/17/24.
//

import SwiftUI
import Supabase

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var result: Result<Void, Error>?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Email")) {
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Password")) {
                    SecureField("Enter a password", text: $password)
                }
                
                if isLoading {
                    Section {
                        ProgressView()
                    }
                } else {
                    Section {
                        Button("Sign Up") {
                            signUpButtonTapped()
                        }
                    }
                }
                
                if let result {
                    Section {
                        switch result {
                        case .success:
                            Text("Sign Up successful.").foregroundStyle(.green)
                        case .failure(let error):
                            Text(error.localizedDescription).foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
    }

    func signUpButtonTapped() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let _ = try await supabase.auth.signUp(
                    email: email,
                    password: password
                )
                self.result = .success(())
            } catch {
                self.errorMessage = error.localizedDescription
                self.result = .failure(error)
            }
        }
    }
}

#Preview {
    SignUpView()
}
