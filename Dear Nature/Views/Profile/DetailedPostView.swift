//
//  DetailedPostView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-05.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct DetailedPostView: View {
    @Binding var showingPostView: Bool
    @ObservedObject var userViewModel : UserViewModel
    @Binding var scrollIndex: Int
    var user: User
    var body: some View {
        ScrollView(.vertical) {
            ScrollViewReader { position in
                VStack {
                    HStack {
                        Button(action: {
                            showingPostView = false
                        }) {
                            
                            Image(systemName: "chevron.down.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white,.black.opacity(0.6))
                                .padding()
                        }
                        Spacer()
                    }
                    ForEach(Array(userViewModel.userPosts.enumerated()), id: \.element) { index, post in
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
                                .padding(.top)
                                .padding(.leading)
                            
                            Text("@\(user.username ?? "Username")")
                                .foregroundColor(.white)
                                .padding(.top)
                            
                            Spacer()
                            Text(post.date)
                                .foregroundColor(.white)
                                .padding(.trailing,10)
                                .padding(.top)

                        }
                        
                        WebImage(url: URL(string: post.postImage))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .id(index)
                        
                        
                        Text(post.caption)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .topLeading)
                            .padding(3)
                        
                        
                        Button(action: {
                            
                        }) {
                            HStack (spacing: 2) {
                                Image(systemName: "text.bubble")
                                    .foregroundColor(.pink)
                                Text("Comments")
                                    .foregroundColor(.black)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.045)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                            
                            
                        }
                        
                    }.onAppear {
                        position.scrollTo(scrollIndex, anchor: .center)
                    }
                }
            }
            
        }
        
    }
}
