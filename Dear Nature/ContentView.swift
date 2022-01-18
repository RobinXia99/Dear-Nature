//
//  ContentView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import SwiftUI

struct ContentView: View {
    
    let gradient = Gradient(colors: [Color.init(red: 56/256, green: 217/256, blue: 118/256),Color.init(red: 62/256, green: 218/256, blue: 116/256),Color.init(red: 118/256, green: 226/256, blue: 93/256),Color.init(red: 143/256, green: 222/256, blue: 137/256)])
    
    let tabBarImages = ["house","magnifyingglass","plus.app.fill","mappin","person.circle"]
    
    @State var selectedIndex = 1
    
    @State var loggedIn = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        
        ZStack {
            
            if !loggedIn {
                LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                
            } else {
                VStack() {
                    
                    NavigationView {
                        ZStack {
                            LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                            
                            switch selectedIndex {
                                
                            case 0:
                                Text("Homescreen")
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
                                selectedIndex = num
                            }, label: {
                                
                                Spacer()
                                
                                if num == 2 {
                                    Image(systemName: tabBarImages[num])
                                        .font(.system(size: 45, weight: .bold)).foregroundColor(.black)
                                } else {
                                    Image(systemName: tabBarImages[num])
                                        .font(.system(size: 24, weight: .bold)).foregroundColor(selectedIndex == num ? Color(.black) : .gray)
                                }
                                
                                Spacer()
                                
                            })
                        }
                        
                    }
                }
            }
            
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
