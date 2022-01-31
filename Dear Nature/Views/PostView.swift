//
//  PostView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-30.
//

import SwiftUI

struct PostView: View {
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    @State var showingPostingView = false
    let appearance = UINavigationBarAppearance()
    
    init() {
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                NavigationLink(destination: EditPostView(image: $image, inputImage: $inputImage), isActive: $showingPostingView) { EmptyView() }
                
                Button("Upload Photo") {
                    showingImagePicker.toggle()
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }.onChange(of: inputImage) { _ in changeView()}
            }
            
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    

    
    func changeView() {
        guard inputImage != nil else { return }
        showingPostingView = true

    }
    
}

struct EditPostView: View {
    
    @Binding var image: Image?
    @Binding var inputImage: UIImage?
    
    var body: some View {
        
        ZStack {
            image?
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -3)
                .padding(.bottom,10)
        }.onAppear {
            loadImage()
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)

    }
    
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
