//
//  TabView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-19.
//

import SwiftUI

struct TabView: View {
    
    @State var selectedTab = 0
    
    let tabBarImages = ["house","magnifyingglass","plus.app.fill","mappin","person.circle"]
    
    let gradient = Gradient(colors: [Color.init(red: 56/256, green: 161/256, blue: 217/256),Color.init(red: 67/256, green: 175/256, blue: 201/256),Color.init(red: 91/256, green: 221/256, blue: 226/256),Color.init(red: 137/256, green: 222/256, blue: 219/256)])
    
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    
                    LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                        
                        switch selectedTab {
                            
                        case 0:
                            Text("Home")
                        case 1:
                            Text("Explore")
                        case 3:
                            Text("Maps")
                        case 4:
                            Text("Profile")
                        default:
                            Text("Photo Selector")
                            
                            
                        }
                    

                }
            }
                
            
            Spacer()
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
                
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
