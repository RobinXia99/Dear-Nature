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
    
    var theme = Themes()
    
    var width = UIScreen.main.bounds.width * 0.95
    
    var body: some View {
        VStack (spacing: 5){
            
            Color.white
                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.7)
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
                        
                    }

                    
                }
            
            Button(action: {

                
            }) {
                Text("Save Changes")
                    .foregroundColor(.blue)
                    .frame(width: width, height: UIScreen.main.bounds.height * 0.05)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 2)
                    .padding(5)
                
            }
            
            Button(action: {

            }) {
                Text("Delete Place")
                    .foregroundColor(.red)
                    .frame(width: width, height: UIScreen.main.bounds.height * 0.05)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 2)
                
            }.padding(.bottom,50)
               
            
        }
    }
}

struct PlaceItems: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Binding var mapNameText: String
    @Binding var toggleSwitch: Bool
    @Binding var selectedRegion: String
    @State var showingImagePicker = false
    @State var image: Image?
    @Binding var inputImage: UIImage?
    var theme = Themes()
    var regions = ["International", "Asia", "Europe", "North America", "South America", "Australia", "Africa", "Antarctica"]
    
    var body: some View {
        HStack {
            
            ZStack {
                
                
                WebImage(url: URL(string: mapViewModel.currentMap?.mapImage ?? ""))
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
        }.padding()

        HStack {
            
        }
            
            
            .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)

    }
}
