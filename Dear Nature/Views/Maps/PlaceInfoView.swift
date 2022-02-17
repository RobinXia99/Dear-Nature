//
//  PlaceInfoView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-16.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaceInfoView: View {
    
    @ObservedObject var mapViewModel: MapViewModel
    @State private var showInfo = false
    @Binding var showingPlaceSettings: Bool
    
    
    var place: Place
    var theme = Themes()
    
    var body: some View {
        ZStack {
            
            Image(systemName: place.markerSymbol)
                .font(.largeTitle)
                .foregroundColor(getMarkerColor(symbol: place.markerSymbol))
                .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
            
            if showInfo {
                Color.white
                    .frame(width: UIScreen.main.bounds.width * 0.58, height: UIScreen.main.bounds.height * 0.17)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
                    .overlay {
                        VStack {
                            HStack {
                                WebImage(url: URL(string: place.placeImage))
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
                                    .padding(.leading,5)
                                Spacer()
                                
                                Button(action: {
                                    showingPlaceSettings = true
                                    
                                }) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.title2)
                                        .foregroundColor(theme.pinkTheme)
                                }
                                .fullScreenCover(isPresented: $showingPlaceSettings) {
                                    ZStack {
                                        PlaceSettingsView(mapViewModel: mapViewModel, showingPlaceSettings: $showingPlaceSettings, place: place)
                                            .background(BackgroundClearView().ignoresSafeArea())
                                    }
                                    
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
    
    func getMarkerColor(symbol: String) -> Color {
        
        switch symbol {
        case "mappin":
            return Color.red
        case "drop.fill":
            return Color.blue
        case "pawprint.fill":
            return Color.brown
        case "leaf.fill":
            return Color.green
        default:
            return Color.black
        }
    }
    
}
