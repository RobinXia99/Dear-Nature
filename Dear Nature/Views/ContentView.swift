//
//  ContentView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    
    
    var body: some View {
        Group {
            ZStack {
                if !authHandler.isSignedIn {
                    LoginView()
                } else {
                    TabView()
                }
            }
        }.onAppear(perform: getUser)
        
    }
    
    func getUser() {
        authHandler.listenToUserChanges()
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authHandler = AuthViewModel()
        ContentView()
            .environmentObject(authHandler)
        
    }
}

