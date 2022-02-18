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
    @StateObject var userViewModel = UserViewModel()
    @StateObject var mapViewModel = MapViewModel()
    @StateObject var mapInspectViewModel = MapInspectViewModel()
    
    
    var themes = Themes()

    
    var body: some View {
        NavigationView {
            ScrollView (.vertical) {
                VStack {
                    ZStack {
                        Image("whiteborder")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.38)
                        ProfileHeader(user: authHandler.session ?? returnUserIfNil(), userViewModel: userViewModel)

                        Spacer()
                    }
                    Picker("", selection: $pickerSelection) {
                        Image(systemName: "square.grid.3x3")
                            .tag("photos")
                        Image(systemName: "map")
                            .tag("maps")
                    }.pickerStyle(SegmentedPickerStyle()).padding(5)
                    
                    
                    if pickerSelection == "photos" {
                        UserPostsGrid(userViewModel: userViewModel)
                    } else {
                        UserMapsGrid(mapInspectViewModel: mapInspectViewModel)
                    }
                }
            }
            .padding(.bottom,90)
            .ignoresSafeArea()
            .onAppear {
                userViewModel.getUserPosts(user: authHandler.session)
                mapInspectViewModel.retrieveUsersMaps(user: authHandler.session)
            }

            
            
            .navigationBarTitle("@\(authHandler.session?.username ?? "@Username")", displayMode: .inline)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                    Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "sun.max.circle.fill")
                                .font(.title2)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white,.black.opacity(0.6))
                                
                        })
                        
                        Button(action: {
                            do {
                                try authHandler.auth.signOut()
                                authHandler.isSignedIn = false
                                authHandler.session = nil
                            } catch {
                                
                            }
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
    
    func returnUserIfNil() -> User {
        let newUser = User(uid: "yes", email: "hey")
        return newUser
    }
    
}





struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
