//
//  TabView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-19.
//

import SwiftUI

struct TabsView: View {
    
    @State var selectedTab = 0
    @EnvironmentObject var authHandler: AuthViewModel
    
    var themes = Themes()
    
    var body: some View {
        
        ZStack {
            
            switch selectedTab {
                
            case 0:
                HomeView()
            case 1:
                DiscoverView()
            case 3:
                MapView()
            case 4:
                ProfileView()
            default:
                PostView()
                
                
            }
            
            
            
            VStack {
                Spacer()
                TabBar(selectedTab: $selectedTab)
            }
            
        }
        
    }

    
    
    
}

struct TabBar: View {
    
    let tabBarImages = ["house","safari","plus.app.fill","map.fill","person.circle"]
    
    let tabBarTitles = ["Home", "Discover", "", "Maps","Profile"]
    
    @Binding var selectedTab: Int
    var theme = Themes()
    
    var body: some View {
        HStack {
            
            ForEach(0..<5) { num in
                Button(action: {
                    selectedTab = num
                }, label: {
                    
                    Spacer()
                    
                    if num == 2 {
                        Image(systemName: tabBarImages[num])
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(theme.pinkTheme)
                    } else {
                        VStack {
                            Image(systemName: tabBarImages[num])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedTab == num ? theme.pinkTheme : .gray)
                            Text(tabBarTitles[num])
                                .font(.footnote)
                                .foregroundColor(selectedTab == num ? theme.pinkTheme : .gray)
                        }
                        
                    }
                    
                    Spacer()
                    
                })
            }
            
        }
        .padding(.top,5)
        .background(.white)
        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
    }
    
    
}

