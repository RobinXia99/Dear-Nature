//
//  HomeView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-26.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    @State var isNewUser: Bool = false
    var themes = Themes()
    
    var body: some View {
        NavigationView {
            
            ZStack {
                LinearGradient(gradient: themes.blueGradient, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
                Button(action: {
                    do {
                        try authHandler.auth.signOut()
                        authHandler.isSignedIn = false
                    } catch {
                        
                    }

                }, label: {
                    Text("Sign Out")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding().frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.04)
                        .background(themes.blackButtonColor)
                        .cornerRadius(15)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                })
                
            }
            .navigationBarTitle("Home")
            .fullScreenCover(isPresented: $isNewUser) {
                GetStartedView(isNewUser: $isNewUser)
            }
            
        }
        .onAppear {
            checkIfNewUser()
        }
        
    }
    
    func checkIfNewUser() {
        if authHandler.session?.username == "" {
            isNewUser = true
            print("showing sheet")
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
