//
//  ProfileView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    
    var themes = Themes()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: themes.blueGradient, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            .navigationBarTitle("@Username")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
