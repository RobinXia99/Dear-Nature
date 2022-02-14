//
//  MapView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-11.
//

import SwiftUI
import MapKit

struct MapView: View {
    let locationManager = LocationManager()
    
    @StateObject var mapViewModel = MapViewModel()
    @State var showUserLocation = false
    @State var showingMapList = false
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
    
    @State var emptyMap = [Place(id: UUID(), name: "A Place", placeImage: "", markerSymbol: "", placeInfo: "", latitude: 37.34233141, longitude: -122.0312186)]
    
    var body: some View {
        ZStack {
            
            if let currentMap = mapViewModel.currentMap {
                Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: showUserLocation, userTrackingMode: .constant(.follow), annotationItems: currentMap.places) { place in
                    
                   // MapPin(coordinate: place.coordinate)
                    MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                        VStack {
                            Image(systemName: place.markerSymbol).resizable().frame(width: 44, height: 44).foregroundColor(.red)
                        }
                        
                    }
         
                }.ignoresSafeArea()
            } else {
                Map(coordinateRegion: $region)
                    .ignoresSafeArea()
            }
            
            
            MenuBar(showingMapList: $showingMapList)
            
        }
        .onAppear {
            mapViewModel.getUserMaps()
        }
        .fullScreenCover(isPresented: $showingMapList) {
            ZStack {
                Color.black.opacity(0.74).ignoresSafeArea()
                MapSelectView(mapViewModel: mapViewModel, showingMapList: $showingMapList)
                    .background(BackgroundClearView().ignoresSafeArea())
            }
            
        }
        
    }
}

struct MenuBar: View {
    @Binding var showingMapList: Bool
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Color.black.opacity(0.2)
                    .frame(width: 50, height: 220)
                    .cornerRadius(25)
                    .overlay {
                        ZStack {
                            Capsule(style: .continuous)
                                .stroke(Color.white, lineWidth: 2)
                            VStack (spacing: 10) {
                                Button(action: {
                                    showingMapList = true
                                }) {
                                    Image(systemName: "map.circle.fill")
                                        .font(.largeTitle)
                                }
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "gearshape.circle.fill")
                                        .font(.largeTitle)
                                }
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "location.circle.fill")
                                        .font(.largeTitle)
                                }
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .font(.largeTitle)
                                }
                            }
                        }
                        
                    }
            }.padding()
            Spacer()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
