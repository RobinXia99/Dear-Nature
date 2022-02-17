//
//  MapSelectView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-12.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit

struct MapSelectView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var showingMapList: Bool
    @Binding var region: MKCoordinateRegion
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
                
                MapList(mapViewModel: mapViewModel, showingMapList: $showingMapList, region: $region)
                
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
    
    
}

struct MapList: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var showingMapList: Bool
    @Binding var region: MKCoordinateRegion
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
                        mapViewModel.getPlaces()
                        showingMapList = false
                        changeRegion()
                        
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
    
    func changeRegion() {
        if mapViewModel.currentMap != nil {
            switch mapViewModel.currentMap?.region {
            case "International":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.31086991759319, longitude: 18.02968330944866), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180))
            case "Asia":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.467910, longitude: 92.626292), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
                print("asia")
            case "Europe":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.809798, longitude: 23.527997), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
            case "Africa":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 4.520489, longitude: 22.054558), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
            case "South America":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -16.151880, longitude: -59.905403), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
            case "North America":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.053033, longitude: -104.860522), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
            case "Antarctica":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -76.240113, longitude: 23.553510), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
            case "Australia":
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -25.848859, longitude: 134.422318), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
            default:
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.31086991759319, longitude: 18.02968330944866), span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180))
            }
        }
    }

}

