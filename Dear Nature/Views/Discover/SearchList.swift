//
//  SearchList.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-07.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct SearchList: View {
    
    @Binding var searchText: String
    @Binding var listOfUsers: [User]
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        List {
            ForEach(searchResults) { user in
                NavigationLink {
                    OtherProfileView(user: user, userViewModel: userViewModel)
                } label: {
                    HStack {
                        WebImage(url: URL(string: user.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .cornerRadius(50)
                            .overlay {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 1)
                            }
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            .padding(.leading)
                        
                        Text("@\(user.username ?? "Username")")
                            .foregroundColor(.black)
                            .padding(.leading,3)
                        
                    }
                }
                
                
            }
            
        }
    }
    var searchResults: [User] {
        if searchText.isEmpty {
            return listOfUsers
        } else {
            return listOfUsers.filter { $0.username!.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

