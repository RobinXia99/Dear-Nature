//
//  ContentView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authHandler: AuthManager
    
    var body: some View {
        
        Group {
            ZStack {
                
                if !authHandler.isSignedIn {
                    LoginView()
                } else {
                    TabView()
                }
            }
            
            
            
        }
        
        
        
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authHandler = AuthManager()
        ContentView()
            .environmentObject(authHandler)
        
    }
}

