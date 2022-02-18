//
//  FeaturedMapsGrid.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-17.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserMapsGrid: View {
    
    @ObservedObject var mapInspectViewModel : MapInspectViewModel
    @State var showingMapsView = false
    @State var selectedMap: UserMap? = nil
    
    var columnGrid: [GridItem] = [GridItem(.flexible(), spacing: 5), GridItem(.flexible(), spacing: 5)]
    
    var body: some View {
        LazyVGrid(columns: columnGrid, spacing: 10) {
            
            ForEach(mapInspectViewModel.maps) { map in
                
                
                WebImage(url: URL(string: map.mapImage))
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.48, height: UIScreen.main.bounds.height * 0.15)
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
                                    
                                }.frame(width: UIScreen.main.bounds.width * 0.48, height: UIScreen.main.bounds.height * 0.05)
                                    .background(.black.opacity(0.66))
                                    .cornerRadius(10)
                            }
                        
                        
                    }.onTapGesture {
                        mapInspectViewModel.retrieveMapPlaces(map: map) { _ in
                            if map.isPublic {
                                self.selectedMap = map
                                showingMapsView = true
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showingMapsView) {
                        
                        MapInspectView(showingMapsView: $showingMapsView, mapInspectViewModel: mapInspectViewModel, selectedMap: $selectedMap)
                        
                    }
                
                
            }
        }
    }
}


