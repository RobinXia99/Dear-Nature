//
//  ProfileHeader.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-05.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct ProfileHeader: View {
    
    var user: User
    @EnvironmentObject var authHandler: AuthViewModel
    var buttonText = "Edit Profile"
    
    var body: some View {
        
            VStack {
                HStack (spacing: 5) {
                    
                    Group {
                        WebImage(url: URL(string: user.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .cornerRadius(50)
                            .overlay {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 1)
                            }.padding(.leading,25)
                        
                        Text(getFirstName())
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                            .padding(.leading,5)
                    }
                    
                    Spacer()
                    if user == authHandler.session {
                        EditProfileButton()
                    } else {
                        FollowButton()
                    }
                    
                }.padding()
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Followers")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Text("8 888")
                            .foregroundColor(.black)
                    }.padding(.leading,20)
                    Spacer()
                    VStack {
                        Text("Following")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Text("10")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    VStack {
                        Text("Likes")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Text("12M")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    
                }
                
            }
            
        
        

        
    }
    
    func getFirstName() -> String {
        var firstName = ""
        
        if let fullName = user.fullName {
            let fullNameArr = fullName.components(separatedBy: " ")
            firstName = fullNameArr[0]
        }
        return firstName
    }
    
}

struct FollowButton: View {
    var body: some View {
        Button(action: {
            print()
        }, label: {
            Text("Follow")
                .font(.body)
                .foregroundColor(.white)
                .padding().frame(width: UIScreen.main.bounds.width * 0.32, height: UIScreen.main.bounds.height * 0.038)
                .background(.pink)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
        }).padding()
    }
}

struct EditProfileButton: View {
    var body: some View {
        Button(action: {
            print()
        }, label: {
            Text("Edit Profile")
                .font(.body)
                .foregroundColor(.white)
                .padding().frame(width: UIScreen.main.bounds.width * 0.32, height: UIScreen.main.bounds.height * 0.038)
                .background(.pink)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
        }).padding()
    }
}
