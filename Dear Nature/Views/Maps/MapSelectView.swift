//
//  MapSelectView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-12.
//

import SwiftUI

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
                        mapService.createMap()
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
                    theme.international
                        .frame(height: UIScreen.main.bounds.height * 0.14)
                        .cornerRadius(15)
                        .overlay {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 2)
                                
                                    HStack (alignment: .center) {
                                        Image("shennongjia")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: UIScreen.main.bounds.width * 0.26, height: UIScreen.main.bounds.width * 0.26)
                                            .cornerRadius(10)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.white, lineWidth: 2)
                                                    .shadow(radius: 1)
                                            }.padding(8)
                                        
                                        VStack (spacing: 10){
                                            HStack  {
                                                Text(map.mapName)
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                Spacer()
                                            }
                                            HStack  {
                                                Image(systemName: "pin.fill")
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                Text("\(map.places.count)")
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                Spacer()
                                            }
                                            
                                            HStack  {
                                                Image(systemName: "globe.asia.australia.fill")
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                Text(map.region)
                                                    .foregroundColor(.white)
                                                    .font(.body)
                                                Spacer()
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                        Image(systemName: map.isPublic ? "lock.open.fill" : "lock.fill")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
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

}

