//
//  CredentialsValidator.swift
//  Lab1-iOS
//
//  Created by Michal Fereniec on 29/01/2026.
//

import Foundation

struct CredentialsValidator {
    
    enum ValidationError: Error, Equatable {
        case usernameTooShort
        case usernameContainsInvalidCharacters
        case passwordTooShort
        case passwordMissingLetters
        case passwordMissingDigits
        case passwordContainsHTML
        case usernameContainsHTML
        
        var localizedDescription: String {
            switch self {
            case .usernameTooShort:
                return "Login musi mieć co najmniej 3 znaki."
            case .usernameContainsInvalidCharacters:
                return "Login zawiera niedozwolone znaki."
            case .passwordTooShort:
                return "Hasło musi mieć min. 8 znaków."
            case .passwordMissingLetters:
                return "Hasło musi zawierać litery."
            case .passwordMissingDigits:
                return "Hasło musi zawierać cyfry."
            case .passwordContainsHTML:
                return "Hasło zawiera niedozwolone znaczniki HTML (podatność XSS)."
            case .usernameContainsHTML:
                return "Login zawiera niedozwolone znaczniki HTML (podatność XSS)."
            }
        }
    }
    
    struct ValidationResult {
        let isValid: Bool
        let sanitizedUsername: String
        let sanitizedPassword: String
        let errors: [ValidationError]
    }
    
    static func validate(username: String, password: String) -> ValidationResult {
        var errors: [ValidationError] = []
        
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if containsHTML(trimmedUsername) {
            errors.append(.usernameContainsHTML)
        }
        
        if trimmedUsername.count < 3 {
            errors.append(.usernameTooShort)
        }
        
        if containsHTML(trimmedPassword) {
            errors.append(.passwordContainsHTML)
        }
        
        if trimmedPassword.count < 8 {
            errors.append(.passwordTooShort)
        }
        
        if trimmedPassword.rangeOfCharacter(from: .letters) == nil {
            errors.append(.passwordMissingLetters)
        }
        
        if trimmedPassword.rangeOfCharacter(from: .decimalDigits) == nil {
            errors.append(.passwordMissingDigits)
        }
        
        let sanitizedUsername = sanitizeInput(trimmedUsername)
        let sanitizedPassword = sanitizeInput(trimmedPassword)
        
        return ValidationResult(
            isValid: errors.isEmpty,
            sanitizedUsername: sanitizedUsername,
            sanitizedPassword: sanitizedPassword,
            errors: errors
        )
    }
    
    private static func containsHTML(_ input: String) -> Bool {
        let htmlPattern = "<[^>]+>"
        let regex = try? NSRegularExpression(pattern: htmlPattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: input.utf16.count)
        return regex?.firstMatch(in: input, options: [], range: range) != nil
    }
    
    private static func sanitizeInput(_ input: String) -> String {
        var sanitized = input
        sanitized = sanitized.replacingOccurrences(of: "<", with: "&lt;")
        sanitized = sanitized.replacingOccurrences(of: ">", with: "&gt;")
        sanitized = sanitized.replacingOccurrences(of: "\"", with: "&quot;")
        sanitized = sanitized.replacingOccurrences(of: "'", with: "&#39;")
        sanitized = sanitized.replacingOccurrences(of: "&", with: "&amp;")
        return sanitized
    }
}