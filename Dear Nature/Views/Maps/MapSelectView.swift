//
//  MapSelectView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-12.
//

import SwiftUI
import SDWebImageSwiftUI

struct MapSelectView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var showingMapList: Bool
    var mapService = MapService()
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        showingMapList = false
                    }) {
                        
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white,.black.opacity(0.6))
                            .padding(25)
                    }
                    Spacer()
                }
                Text("My Maps")
                    .font(.title)
                    .foregroundColor(.white)
                CustomDivider()
                MapList(mapViewModel: mapViewModel, showingMapList: $showingMapList)
                CustomDivider()
                HStack {
                    Text("\(mapViewModel.myMaps.count)/10")
                        .foregroundColor(.white)
                        .font(.title)
                    Spacer()
                }.padding(.leading)
                HStack {
                    Spacer()
                    Button(action: {
                        if mapViewModel.myMaps.count < 10 {
                            mapService.createMap()
                        }
                        
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.pink,.white)
                            .font(.system(size: 50))
                    }.padding()
                }
                
                
            }
        }
    }
    
    func addNewMap() {
        
    }
    
}

struct MapList: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var showingMapList: Bool
    var theme = Themes()
    var body: some View {
        ScrollView {
            ForEach(Array(mapViewModel.myMaps)) { map in
                getCardColor(region: map.region)
                        .frame(height: UIScreen.main.bounds.height * 0.14)
                        .cornerRadius(15)
                        .overlay {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                                
                                    HStack (alignment: .center) {
                                        WebImage(url: URL(string: map.mapImage))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.26, height: UIScreen.main.bounds.width * 0.26)
                                            .cornerRadius(10)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.white, lineWidth: 2)
                                                    .shadow(radius: 1)
                                            }.padding(8)
                                            .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                        
                                        VStack (spacing: 10){
                                            HStack  {
                                                Text(map.mapName)
                                                    .foregroundColor(.white)
                                                    .font(.title3)
                                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                                Spacer()
                                            }
                                            HStack  {
                                                Image(systemName: "pin.fill")
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                                Text("\(map.places.count)")
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                                Spacer()
                                            }
                                            
                                            HStack  {
                                                Image(systemName: "globe.asia.australia.fill")
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                                Text(map.region)
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                                Spacer()
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                        Image(systemName: map.isPublic ? "lock.open.fill" : "lock.fill")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                            .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                            .padding()
                                    }
                                
                                
                            }
                            
                        }.padding(.horizontal,15)
                    .padding(.top,8)
                    .onTapGesture {
                        mapViewModel.currentMap = map
                        showingMapList = false
                    }
                
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.6)
        
    }
    
    func getCardColor(region: String) -> Color {
        switch region {
        case "International":
            return theme.international!
        case "Asia":
            return theme.asia!
        case "Europe":
            return theme.europe!
        case "Africa":
            return theme.africa!
        case "South America":
            return theme.southAmerica!
        case "North America":
            return theme.northAmerica!
        case "Antarctica":
            return theme.antarctica!
        case "Australia":
            return theme.australia!
        default:
            return theme.international!
        }
    }

}

