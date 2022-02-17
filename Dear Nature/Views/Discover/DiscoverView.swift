//
//  DiscoverView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-05.
//

import SwiftUI

struct DiscoverView: View {
    @State var searchText = ""
    @State var isSearching = false
    @State var listOfUsers = [User]()
    

    var body: some View {
        NavigationView {
            ZStack {

                
                VStack {
                    SearchBar(searchText: $searchText, isSearching: $isSearching, listOfUsers: $listOfUsers)

                    ScrollView {
                        EventSlideShow()
                    }
                    Spacer()
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


struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}

