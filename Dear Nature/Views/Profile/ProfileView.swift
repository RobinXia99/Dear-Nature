//
//  ProfileView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    @State var pickerSelection = "photos"
    @StateObject var userPostViewModel = UserViewModel()
    
    
    var themes = Themes()

    
    var body: some View {
        NavigationView {
            ScrollView (.vertical) {
                VStack {
                    ZStack {
                        Image("whiteborder")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.38)
                        ProfileHeader(user: authHandler.session!)

                        Spacer()
                    }
                    Picker("", selection: $pickerSelection) {
                        Image(systemName: "square.grid.3x3")
                            .tag("photos")
                        Image(systemName: "map")
                            .tag("maps")
                    }.pickerStyle(SegmentedPickerStyle()).padding(5)
                    
                    
                    if pickerSelection == "photos" {
                        UserPostsGrid(userPostViewModel: userPostViewModel, user: authHandler.session!)
                    } else {
                        EmptyView()
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                userPostViewModel.getUserPosts(user: authHandler.session)
            }

            
            
            .navigationBarTitle("@\(authHandler.session?.username ?? "@Username")", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "list.bullet.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white,.black.opacity(0.6))
                            
                    })
                }
            }
        }
    }
}





struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
