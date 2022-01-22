//
//  Dear_NatureApp.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct Dear_NatureApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            let authHandler = AuthViewModel()
            ContentView()
                .environmentObject(authHandler)
        }
    }
}



