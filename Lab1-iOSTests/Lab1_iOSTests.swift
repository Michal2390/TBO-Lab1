//
//  Lab1_iOSTests.swift
//  Lab1-iOSTests
//
//  Created by Michal Fereniec on 29/01/2026.
//

import Testing
@testable import Lab1_iOS

struct Lab1_iOSTests {

    @Test func testUsernameTooShort() async throws {
        let result = CredentialsValidator.validate(username: "ab", password: "Pass1234")
        
        #expect(!result.isValid)
        #expect(result.errors.contains(.usernameTooShort))
    }
    
    @Test func testPasswordTooShort() async throws {
        let result = CredentialsValidator.validate(username: "admin", password: "Pass1")
        
        #expect(!result.isValid)
        #expect(result.errors.contains(.passwordTooShort))
    }
    
    @Test func testPasswordMissingLetters() async throws {
        let result = CredentialsValidator.validate(username: "admin", password: "12345678")
        
        #expect(!result.isValid)
        #expect(result.errors.contains(.passwordMissingLetters))
    }
    
    @Test func testPasswordMissingDigits() async throws {
        let result = CredentialsValidator.validate(username: "admin", password: "Password")
        
        #expect(!result.isValid)
        #expect(result.errors.contains(.passwordMissingDigits))
    }
    
    @Test func testUsernameContainsHTML() async throws {
        let result = CredentialsValidator.validate(username: "admin<script>alert('XSS')</script>", password: "Pass1234")
        
        #expect(!result.isValid)
        #expect(result.errors.contains(.usernameContainsHTML))
    }
    
    @Test func testPasswordContainsHTML() async throws {
        let result = CredentialsValidator.validate(username: "admin", password: "Pass1234<img src=x>")
        
        #expect(!result.isValid)
        #expect(result.errors.contains(.passwordContainsHTML))
    }
    
    @Test func testValidCredentials() async throws {
        let result = CredentialsValidator.validate(username: "admin", password: "Pass1234")
        
        #expect(result.isValid)
        #expect(result.errors.isEmpty)
        #expect(result.sanitizedUsername == "admin")
        #expect(result.sanitizedPassword == "Pass1234")
    }
    
    @Test func testSanitization() async throws {
        let result = CredentialsValidator.validate(username: "test<tag>", password: "Pass1234<img>")
        
        #expect(!result.isValid)
        #expect(result.sanitizedUsername.contains("&lt;"))
        #expect(result.sanitizedUsername.contains("&gt;"))
        #expect(result.sanitizedPassword.contains("&lt;"))
        #expect(result.sanitizedPassword.contains("&gt;"))
    }
}