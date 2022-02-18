//
//  DiscoverView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-05.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverView: View {
    @State var searchText = ""
    @State var isSearching = false
    @State var listOfUsers = [User]()
    @StateObject var mapInspectViewModel = MapInspectViewModel()
    @StateObject var userViewModel = UserViewModel()
    

    var body: some View {
        NavigationView {
            ZStack {

                
                VStack {
                    SearchBar(searchText: $searchText, isSearching: $isSearching, listOfUsers: $listOfUsers)

                    ScrollView {
                        VStack {
                            EventSlideShow()
                            Divider()
                            HStack {
                                Image(systemName: "map")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text("Maps")
                                    .font(.title3)
                                Spacer()
                            }.padding(5)
                            MapScrollView(mapInspectViewModel: mapInspectViewModel)
                            Divider()
                            HStack {
                                Image(systemName: "photo")
                                    .font(.title)
                                    .foregroundColor(.black)
                                Text("Posts")
                                    .font(.title3)
                                Spacer()
                            }.padding(5)
                            UserPostsGrid(userViewModel: userViewModel)
                        }

                    }.padding(.bottom,40)
                    Spacer()
                }.onAppear {
                    mapInspectViewModel.retrievePublicMaps()
                    userViewModel.getAllPosts()
                }
                
                if isSearching {
                    SearchList(searchText: $searchText, listOfUsers: $listOfUsers)
                        .padding(.top,80)
                }
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

            
            
        }
        
    }

}

struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var listOfUsers: [User]
    var db = DatabaseModel()
    var body: some View {
        HStack {
            HStack{
                TextField("Search...", text: $searchText)
                    .disableAutocorrection(true)
                    .padding(.leading,24)

            }.padding()
                .background(Color(.systemGray5))
                .cornerRadius(6)
                .padding(.horizontal)
                .onTapGesture {
                    if listOfUsers.isEmpty {
                        db.getUserList { userList in
                            listOfUsers = userList
                        }
                        print("updating userlist")
                    }
                    
                    isSearching = true
                }
                .overlay {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.pink)
                        Spacer()
                        if isSearching {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }.padding(.horizontal,32)
                }
                .onChange(of: searchText) { newValue in
                    if searchText != ""  {
                        isSearching = true
                    }
                }
            
            if isSearching  {
                Button(action: {
                    isSearching = false
                    searchText = ""
                }) {
                    Text("Cancel")
                        .foregroundColor(.black)
                }.padding(.trailing,5)
            }
            
        }
        .padding()
        .background(.white)
        
    }
    
}


struct MapScrollView: View {
    @ObservedObject var mapInspectViewModel: MapInspectViewModel
    @State var showingMapsView = false
    @State var selectedMap: UserMap? = nil
    var body: some View {
        ScrollView (.horizontal) {
            HStack {
                
                ForEach(mapInspectViewModel.maps) { map in
                    
                    WebImage(url: URL(string: map.mapImage))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.18)
                        .cornerRadius(10)
                        .overlay {

                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack (alignment: .leading) {
                                            Text(map.mapName)
                                                .font(.callout)
                                                .foregroundColor(.white)
                                            HStack (spacing: 2){
                                                Image(systemName: "globe.asia.australia.fill")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                Text(map.region)
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                Image(systemName: "pin.fill")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                Text(String(map.places.count))
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                            }
                                        }.padding(.leading,2)
                                        
                                        Spacer()
                                        
                                        Image(systemName: map.isPublic ? "lock.open.fill": "lock.fill")
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .padding(1)
                                        
                                    }.frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.06)
                                        .background(.black.opacity(0.66))
                                        .cornerRadius(10)
                                }
                            
                            
                        }.onTapGesture {
                            mapInspectViewModel.retrieveMapPlaces(map: map) { _ in
                                self.selectedMap = map
                                showingMapsView = true
                            }
                        }
                        .fullScreenCover(isPresented: $showingMapsView) {
                            
                            MapInspectView(showingMapsView: $showingMapsView, mapInspectViewModel: mapInspectViewModel, selectedMap: $selectedMap)
                            
                        }
                    
                }
                
            }
        }.frame(width: UIScreen.main.bounds.width * 0.98, height: UIScreen.main.bounds.height * 0.2)
    }
}
