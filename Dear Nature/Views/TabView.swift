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
                Text("Maps")
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
    
    let tabBarImages = ["house","safari","plus.app.fill","mappin","person.circle"]
    
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            
            ForEach(0..<5) { num in
                Button(action: {
                    selectedTab = num
                }, label: {
                    
                    Spacer()
                    
                    if num == 2 {
                        Image(systemName: tabBarImages[num])
                            .font(.system(size: 45, weight: .bold)).foregroundColor(.black)
                    } else {
                        Image(systemName: tabBarImages[num])
                            .font(.system(size: 24, weight: .bold)).foregroundColor(selectedTab == num ? Color(.black) : .gray)
                    }
                    
                    Spacer()
                    
                })
            }
            
        }.background(.white)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
