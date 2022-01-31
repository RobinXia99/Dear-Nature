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
                
            }
            .navigationBarTitle("@\(authHandler.session?.username ?? "@Username")")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
