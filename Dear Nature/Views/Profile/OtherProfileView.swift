//
//  OtherProfileView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-09.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherProfileView: View {
    
    @State var user: User
    @State var pickerSelection = "photos"
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var themes = Themes()
    
    var body: some View {
            ScrollView (.vertical) {
                VStack {
                    ZStack {
                        Image("whiteborder")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.38)
                        ProfileHeader(user: user, userViewModel: userViewModel)

                        Spacer()
                    }
                    Picker("", selection: $pickerSelection) {
                        Image(systemName: "square.grid.3x3")
                            .tag("photos")
                        Image(systemName: "map")
                            .tag("maps")
                    }.pickerStyle(SegmentedPickerStyle()).padding(5)
                    
                    
                    if pickerSelection == "photos" {
                        UserPostsGrid(userViewModel: userViewModel, user: user)
                    } else {
                        EmptyView()
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                userViewModel.getUserPosts(user: user)
            }

            
            
            .navigationBarTitle("@\(user.username ?? "@Username")", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white,.black.opacity(0.6))
                    })
                }
                
                
            }
        
    }
}







