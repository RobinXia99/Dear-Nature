//
//  MapInspectView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-17.
//

import SwiftUI
import MapKit

struct MapInspectView: View {
    
    let locationManager = LocationManager()
    let theme = Themes()
    @Binding var showingMapsView: Bool
    
    @ObservedObject var mapInspectViewModel: MapInspectViewModel
    @State var showUserLocation = false
    @State var updatingLocation = false
    @State var userTrackingMode: MapUserTrackingMode = .none
    @Binding var selectedMap: UserMap?
    
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.31086991759319, longitude: 18.02968330944866), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
    
    var body: some View {
        ZStack {
            
            Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: showUserLocation, userTrackingMode: $userTrackingMode, annotationItems: mapInspectViewModel.places) { place in
                
                MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    PlaceInfoNoEdit(mapInspectViewModel: mapInspectViewModel, place: place)
                }
     
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        showingMapsView = false
                    }) {
                        
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white,.black.opacity(0.6))
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
            
        }.onAppear {
            changeRegion()
        }
        
    }
    
    func changeRegion() {
        switch selectedMap?.region {
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
