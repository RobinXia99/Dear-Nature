//
//  HomeView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-26.
//


import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    @StateObject var featuredPostsViewModel = FeaturedPostsViewModel()
    @State var isNewUser: Bool = false
    var themes = Themes()
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical) {
                
                ForEach(featuredPostsViewModel.posts) { post in
                    HStack {
                        Divider()
                        WebImage(url: URL(string: post.userProfileImage ))
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
                        
                        Text("@\(post.userName )")
                            .foregroundColor(.black)
                            .padding(.top)
                        
                        Spacer()
                        Text(post.date)
                            .foregroundColor(.black)
                            .padding(.trailing,10)
                            .padding(.top)

                    }
                    
                    WebImage(url: URL(string: post.postImage))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    
                    Text(post.caption)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .topLeading)
                        .padding(3)
                    Divider()
                }
                
            }
            .padding(.bottom,70)
            .navigationBarTitle("Feed")
            .fullScreenCover(isPresented: $isNewUser) {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    GetStartedView(isNewUser: $isNewUser).background(BackgroundClearView().ignoresSafeArea())
                }
                
            }
            
        }
        .onAppear {
            checkIfNewUser()
            if !isNewUser {
                featuredPostsViewModel.getFollowingPosts(user: authHandler.session!) { _ in
                    print(featuredPostsViewModel.posts)
                }
            }
            
            
        }
        
    }
    
    func checkIfNewUser() {
        if authHandler.session?.username == "" {
            isNewUser = true
            print("showing sheet")
        }
    }
    
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

