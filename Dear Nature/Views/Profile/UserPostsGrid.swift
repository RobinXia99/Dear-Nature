//
//  UserPostGrid.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-05.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct UserPostsGrid: View {
    
    @ObservedObject var userViewModel : UserViewModel
    @EnvironmentObject var authHandler: AuthViewModel
    @State var showingPostView = false
    @State var scrollIndex = 0
    var user: User
    
    var columnGrid: [GridItem] = [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)]
    
    var body: some View {
        LazyVGrid(columns: columnGrid, spacing: 1) {

            ForEach(Array(userViewModel.userPosts.enumerated()), id: \.element) { index, post in
                WebImage(url: URL(string: post.postImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
                    .clipped()
                    .onTapGesture {
                        showingPostView = true
                        scrollIndex = index
                        print(scrollIndex)
                    }
                    .fullScreenCover(isPresented: $showingPostView) {
                        ZStack {
                            Color.black.opacity(0.74).ignoresSafeArea()
                            DetailedPostView(showingPostView: $showingPostView, userViewModel: userViewModel, scrollIndex: $scrollIndex, user: user )
                                .background(BackgroundClearView().ignoresSafeArea())
                        }
                        
                    }
            }
        }
    }
}
