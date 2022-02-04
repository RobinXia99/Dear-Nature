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
    @StateObject var userProfileViewModel = UserProfileViewModel()
    
    
    var themes = Themes()

    
    var body: some View {
        NavigationView {
            ScrollView (.vertical) {
                VStack {
                    ZStack {
                        Image("greenprofiletheme")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.38)
                        UserInfoView()

                        Spacer()
                    }
                    Picker("", selection: $pickerSelection) {
                        Image(systemName: "square.grid.3x3")
                            .tag("photos")
                        Image(systemName: "map")
                            .tag("maps")
                    }.pickerStyle(SegmentedPickerStyle()).padding(5)
                    
                    
                    if pickerSelection == "photos" {
                        UserPostsGrid(userProfileViewModel: userProfileViewModel)
                    } else {
                        EmptyView()
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                userProfileViewModel.getUserPosts()
            }

            
            
            .navigationBarTitle("@\(authHandler.session?.username ?? "@Username")", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.white)
                    })
                }
            }
        }
    }
}

struct UserInfoView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    
    var body: some View {
        
            VStack {
                HStack (spacing: 5) {
                    
                    Group {
                        WebImage(url: URL(string: authHandler.session?.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .cornerRadius(50)
                            .overlay {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.white, lineWidth: 2)
                                    .shadow(radius: 1)
                            }.padding(.leading,25)
                        
                        Text(getFirstName())
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .padding(.leading,5)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        print()
                    }, label: {
                        Text("Edit Profile")
                            .font(.body)
                            .foregroundColor(.green)
                            .padding().frame(width: UIScreen.main.bounds.width * 0.32, height: UIScreen.main.bounds.height * 0.038)
                            .background(.white)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                    }).padding()
                }.padding()
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Followers")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("8 888")
                            .foregroundColor(.white)
                    }.padding(.leading,20)
                    Spacer()
                    VStack {
                        Text("Following")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("10")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    VStack {
                        Text("Likes")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text("12M")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                }
                
            }
            
        
        

        
    }
    
    func getFirstName() -> String {
        var firstName = ""
        
        if let fullName = authHandler.session?.fullName {
            let fullNameArr = fullName.components(separatedBy: " ")
            firstName = fullNameArr[0]
        }
        return firstName
    }
    
}

struct UserPostsGrid: View {
    
    @ObservedObject var userProfileViewModel : UserProfileViewModel
    @State var showingPostView = false
    
    var columnGrid: [GridItem] = [GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1), GridItem(.flexible(), spacing: 1)]
    
    var body: some View {
        LazyVGrid(columns: columnGrid, spacing: 1) {
            ForEach(userProfileViewModel.userPosts) { post in
                WebImage(url: URL(string: post.postImage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (UIScreen.main.bounds.width / 3) - 1, height: (UIScreen.main.bounds.width / 3) - 1)
                    .clipped()
                    .onTapGesture {
                        showingPostView = true
                    }
                    .fullScreenCover(isPresented: $showingPostView) {
                        ZStack {
                            Color.black.opacity(0.74).ignoresSafeArea()
                            PhotoPostView(showingPostView: $showingPostView, userProfileViewModel: userProfileViewModel, post: post)
                                .background(BackgroundClearView().ignoresSafeArea())
                        }
                        
                    }
            }
        }
    }
}

struct PhotoPostView: View {
    @Binding var showingPostView: Bool
    @ObservedObject var userProfileViewModel : UserProfileViewModel
    @EnvironmentObject var authHandler: AuthViewModel
    var post: Post
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Button(action: {
                        showingPostView = false
                    }) {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }
                ForEach(userProfileViewModel.userPosts) { post in
                    HStack {
                        Spacer()
                        Text(post.date)
                            .foregroundColor(.white)
                            .padding(5)

                    }
                    
                    WebImage(url: URL(string: post.postImage))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.95)
                        .cornerRadius(5)
                        .overlay {
                            
                            VStack {
                                HStack (spacing: 5) {
                                    WebImage(url: URL(string: authHandler.session?.profileImageUrl ?? ""))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(50)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 50)
                                                .stroke(.white, lineWidth: 2)
                                                .shadow(radius: 1)
                                        }
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                                        .padding(.top)
                                        .padding(.leading)
                                    
                                    Text("@\(authHandler.session?.username ?? "Username")")
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .padding(.top)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "trash.circle.fill")
                                            .resizable()
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.red, .white)
                                            .frame(width: 44, height: 44)
                                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                                            .padding()
                                    }
                                }
                                
                                
                                HStack {
                                    
                                }
                                Spacer()
                            }
                        }
                    
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
                                .foregroundColor(.green)
                            Text("Comments")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.05)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 2)
                        
                        
                    }
                    
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
