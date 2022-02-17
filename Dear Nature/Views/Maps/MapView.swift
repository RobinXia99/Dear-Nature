//
//  MapView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-11.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    let locationManager = LocationManager()
    let theme = Themes()
    
    @StateObject var mapViewModel = MapViewModel()
    @State var showUserLocation = false
    @State var showingMapList = false
    @State var showingMapSettings = false
    @State var isShowingAnotherView = false
    @State var updatingLocation = false
    @State var showingPlaceSettings = false
    @State var userTrackingMode: MapUserTrackingMode = .none
    
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.31086991759319, longitude: 18.02968330944866), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
    
    var body: some View {
        ZStack {
            
            
            
            if mapViewModel.currentMapPlaces != nil {
                Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: showUserLocation, userTrackingMode: $userTrackingMode, annotationItems: mapViewModel.currentMapPlaces!) { place in
                    
                   // MapPin(coordinate: place.coordinate)
                    MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                        PlaceInfoView(mapViewModel: mapViewModel, showingPlaceSettings: $showingPlaceSettings, place: place )
                    }
         
                }
                .ignoresSafeArea()
                
                
            } else {
                Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: showUserLocation)
                    .ignoresSafeArea()
            }
            
            if !isShowingAnotherView {
                MenuBar(locationManager: locationManager, showingMapList: $showingMapList, showingMapSettings: $showingMapSettings, updatingLocation: $updatingLocation, showUserLocation: $showUserLocation, userTrackingMode: $userTrackingMode)
            }

            if mapViewModel.currentMap != nil && showingPlaceSettings == false && showingMapSettings == false {
                VStack {
                    Spacer()
                    Button(action: {
                        placeMarker()
                    }, label: {
                        HStack (spacing: 5) {
                            Text("Place Marker")
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                            Image(systemName: "mappin")
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                        }
                            .font(.title3)
                            .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                            .background(theme.pinkTheme)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
                    }).padding(.bottom, 55)
                }
            }

            
        }
        .onAppear {
            mapViewModel.getUserMaps()
            locationManager.askPermission()
        }
        .fullScreenCover(isPresented: $showingMapList) {
            ZStack {
                Color.black.opacity(0.74).ignoresSafeArea()
                MapSelectView(mapViewModel: mapViewModel, showingMapList: $showingMapList, region: $region)
                    .background(BackgroundClearView().ignoresSafeArea())
            }
            
        }
        .fullScreenCover(isPresented: $showingMapSettings) {
            ZStack {
                MapSettingsView(mapViewModel: mapViewModel, showingMapSettings: $showingMapSettings)
                    .background(BackgroundClearView().ignoresSafeArea())
            }
            
        }
        
        
    }
    
    
    
    func placeMarker() {
        guard let latitude = locationManager.location?.latitude, let longitude = locationManager.location?.longitude else { return }
        mapViewModel.placeMarker(latitude: latitude, longitude: longitude)
    }

}

struct MenuBar: View {
    var locationManager: LocationManager
    @Binding var showingMapList: Bool
    @Binding var showingMapSettings: Bool
    @Binding var updatingLocation: Bool
    @Binding var showUserLocation: Bool
    @Binding var userTrackingMode: MapUserTrackingMode
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
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.pink,.white)
                                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                }
                                
                                Button(action: {
                                    showingMapSettings = true
                                }) {
                                    Image(systemName: "gearshape.circle.fill")
                                        .font(.largeTitle)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.pink,.white)
                                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                }
                                
                                Button(action: {
                                    if updatingLocation {
                                        locationManager.stopUpdatingLocation()
                                        showUserLocation = false
                                        updatingLocation = false
                                        userTrackingMode = .none
                                    } else {
                                        locationManager.startUpdatingLocation()
                                        showUserLocation = true
                                        updatingLocation = true
                                        userTrackingMode = .follow
                                    }
                                }) {
                                    Image(systemName: updatingLocation ? "location.fill": "location.slash.fill")
                                        .font(.largeTitle)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.pink,.white)
                                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                }
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .font(.largeTitle)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.pink,.white)
                                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                }
                            }
                        }
                        
                    }
            }.padding()
            Spacer()
        }
    }
}


