//
//  PlaceInfoView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-16.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaceInfoView: View {
    @State private var showInfo = false
    @State var place: Place
    var theme = Themes()
    
    var body: some View {
        ZStack {
            
            Image(systemName: "mappin")
                .font(.largeTitle)
                .foregroundColor(.red)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
            
            if showInfo {
                Color.white
                    .frame(width: UIScreen.main.bounds.width * 0.58, height: UIScreen.main.bounds.height * 0.17)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                    .overlay {
                        VStack {
                            HStack {
                                WebImage(url: URL(string: place.placeImage ?? ""))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(50)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 50)
                                            .stroke(.white, lineWidth: 1)
                                            .shadow(radius: 1)
                                    }
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                                    .padding(.top)
                                
                                Text(place.name)
                                    .font(.body)
                                    .padding(.top)
                                Spacer()
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.title2)
                                        .foregroundColor(theme.pinkTheme)
                                }
                                
                                    
                                
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.52, height: UIScreen.main.bounds.height * 0.05)
                            .padding(5)
                            
                            Spacer()
                            
                            HStack {
                                Text(place.placeInfo)
                                    .font(.footnote)
                                    
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.52, height: UIScreen.main.bounds.height * 0.07)
                            .background(theme.textFieldGrey)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: -2, y: -2)
                            .padding(.bottom,12)
                                
                            
                                
                            
                        }
                    }.padding(.bottom,170)
            }
            
            
            
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showInfo.toggle()
            }
        }
    }
}
