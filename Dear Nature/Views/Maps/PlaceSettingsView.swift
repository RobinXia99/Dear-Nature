//
//  PlaceSettingsView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-11.
//

import SwiftUI
import SDWebImageSwiftUI
import CoreLocation

struct PlaceSettingsView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var showingPlaceSettings: Bool
    @State var placeNameText = ""
    @State var inputImage: UIImage?
    var place: Place
    @State var selectedMarker = 0
    @State var placeInfoText: String = ""
    
    let markerSymbols = ["mappin","drop.fill","pawprint.fill","leaf.fill","camera.fill"]
    
    
    var theme = Themes()
    
    var body: some View {
        VStack (spacing: 5){
            
            Color.white
                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.6)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 1, y: 1)
                .overlay {
                    VStack {
                        
                        HStack (alignment: .center) {
                            
                            Button(action: {
                                showingPlaceSettings = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 50))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.pink,.white)
                                    .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                
                                
                            }.padding(.leading)
                            
                            TextField("Place Name", text: $placeNameText)
                                .disableAutocorrection(true)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .frame(width: UIScreen.main.bounds.width * 0.5)
                                .autocapitalization(.none)
                                .padding(5)
                                .background(theme.textFieldGrey)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: -1, y: -1)
                                .padding()
                            Spacer()
                            
                            
                            
                        }
                        
                        PlaceItems(mapViewModel: mapViewModel, inputImage: $inputImage, selectedMarker: $selectedMarker, placeInfoText: $placeInfoText, place: place)
                        
                    }
                    
                    
                }
            
            Button(action: {
                mapViewModel.editPlace(place: place, placeName: placeNameText, placeImage: inputImage, markerSymbol: markerSymbols[selectedMarker], placeInfo: placeInfoText) { _ in
                    
                        showingPlaceSettings = false

                    
                }
            }) {
                Text("Save Changes")
                    .foregroundColor(.blue)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.05)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 2)
                    .padding(5)
                
            }
            
            Button(action: {
                mapViewModel.deletePlace(place: place) { _ in
                    showingPlaceSettings = false
                }
            }) {
                Text("Delete Place")
                    .foregroundColor(.red)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.05)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 2)
                
            }.padding(.bottom,50)
            
            
        }.onAppear {
            
            placeNameText = place.name
            placeInfoText = place.placeInfo
            selectedMarker = getMarkerIndex(markerSymbol: place.markerSymbol)

        }
    }
    
    func getMarkerIndex(markerSymbol: String) -> Int {
        switch markerSymbol {
        case "mappin":
            return 0
        case "drop.fill":
            return 1
        case "pawprint.fill":
            return 2
        case "leaf.fill":
            return 3
        default:
            return 4
        }
    }
}

struct PlaceItems: View {
    @ObservedObject var mapViewModel: MapViewModel
    @State var showingImagePicker = false
    @State var image: Image?
    @Binding var inputImage: UIImage?
    @Binding var selectedMarker: Int
    @Binding var placeInfoText: String
    var place: Place
    
    let markerSymbols = ["mappin","drop.fill","pawprint.fill","leaf.fill","camera.fill"]
    var theme = Themes()
    
    var body: some View {
        VStack (alignment: .leading){
            HStack {
                
                ZStack {
                    
                    
                    WebImage(url: URL(string: place.placeImage))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .cornerRadius(50)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.white, lineWidth: 2)
                                .shadow(color: .black.opacity(0.3), radius: 2)
                        }.padding()
                    
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .cornerRadius(50)
                        .padding()
                    
                    
                    
                    
                }.onChange(of: inputImage) { _ in loadImage()}
                
                
                
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    Text("Upload Image")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.04)
                        .background(theme.pinkTheme)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                }.padding()
                Spacer()
            }
            
            Text("Select Marker")
                .padding(15)
            
            ScrollView (.horizontal) {
                HStack {
                    ForEach(0..<5) { num in
                        Button(action: {
                            selectedMarker = num
                        }, label: {
                            
                            
                            
                            Image(systemName: markerSymbols[num])
                                .font(.largeTitle)
                                .foregroundColor(getMarkerColor(symbol: markerSymbols[num]))
                                .shadow(color: .white, radius: 1, x: 2, y: 2)
                                .frame(width: 54, height: 54)
                                .background(selectedMarker == num ? theme.textFieldGrey : theme.pinkTheme?.opacity(0.8))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.3), radius: 1, x: 1, y: 1)
                                .padding(5)
                            
                        })
                    }
                }
                
                
            }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.1)
                .padding(.leading,10)
            
            Text("Place Info")
                .padding(15)
            
            HStack {
                
                TextField("Short description of place...", text: $placeInfoText)
                    .disableAutocorrection(true)
                    .font(.body)
                    .padding()
                
            }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.07)
                .background(theme.textFieldGrey)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.2), radius: 2, x: -2, y: -2)
                .padding(.leading,10)
            
            
            Spacer()
        }
        
        
        
        
        
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
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
