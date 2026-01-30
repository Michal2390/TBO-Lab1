//
//  ContentView.swift
//  Lab1-iOS
//
//  Created by Michal Fereniec on 29/01/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var status: StatusMessage?
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo.opacity(0.85), .black.opacity(0.9)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("SecureGate")
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(.white)
                    Text("Zaloguj się, aby kontynuować")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Login")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.secondary)
                            TextField("np. jan.kowalski", text: $username)
                                .focused($focusedField, equals: .username)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .foregroundStyle(.primary)
                        }
                        .padding(14)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hasło")
                            .font(.callout.weight(.medium))
                            .foregroundStyle(.secondary)
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)

                            Group {
                                if isPasswordVisible {
                                    TextField("••••••••", text: $password)
                                } else {
                                    SecureField("••••••••", text: $password)
                                }
                            }
                            .focused($focusedField, equals: .password)
                            .textContentType(.password)
                            .textInputAutocapitalization(.never)

                            Button {
                                isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .accessibilityLabel(isPasswordVisible ? "Ukryj hasło" : "Pokaż hasło")
                        }
                        .padding(14)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }

                if let status {
                    HStack(spacing: 12) {
                        Image(systemName: status.icon)
                        Text(status.message)
                            .font(.callout.weight(.medium))
                    }
                    .foregroundStyle(status.color)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(status.color.opacity(0.12),
                                in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                Button(action: attemptLogin) {
                    Label("Zaloguj się", systemImage: "arrow.right.circle.fill")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .background(loginButtonBackground,
                            in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .opacity(isFormValid ? 1 : 0.65)
                .disabled(!isFormValid)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Wymagania bezpieczeństwa")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Label("Login zawiera minimum 3 znaki (bez HTML).", systemImage: "checkmark.seal")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                    Label("Hasło ma min. 8 znaków, litery i cyfry (bez HTML).", systemImage: "lock.shield")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(28)
            .frame(maxWidth: 420)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .padding()
        }
        .animation(.easeInOut(duration: 0.25), value: status)
    }

    private var trimmedUsername: String {
        username.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedPassword: String {
        password.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isFormValid: Bool {
        let result = CredentialsValidator.validate(username: trimmedUsername, password: trimmedPassword)
        return result.isValid
    }

    private var loginButtonBackground: AnyShapeStyle {
        if isFormValid {
            AnyShapeStyle(.blue.gradient)
        } else {
            AnyShapeStyle(Color.gray.opacity(0.45))
        }
    }

    private func attemptLogin() {
        let result = CredentialsValidator.validate(username: trimmedUsername, password: trimmedPassword)
        
        guard result.isValid else {
            status = StatusMessage(
                message: result.errors.first!.localizedDescription,
                icon: "exclamationmark.triangle.fill",
                color: .red
            )
            focusedField = result.errors.contains(.usernameTooShort) || result.errors.contains(.usernameContainsHTML) ? .username : .password
            return
        }

        status = StatusMessage(
            message: "✓ Zalogowano pomyślnie jako \(result.sanitizedUsername).",
            icon: "checkmark.circle.fill",
            color: .green
        )
        focusedField = nil
    }

    private enum Field {
        case username
        case password
    }

    private struct StatusMessage: Equatable {
        let message: String
        let icon: String
        let color: Color
    }
}

#Preview {
    ContentView()
}