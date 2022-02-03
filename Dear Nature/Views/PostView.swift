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
    @State var showingImagePreview = false
    @State var showingEditView = false
    var themes = Themes()

    
    var body: some View {
        NavigationView {
            
            ZStack {
                //NavigationLink(destination: ImagePreviewView(image: $image, inputImage: $inputImage), isActive: $showingImagePreview) { EmptyView()}
                
                
                Button(action: {
                    showingImagePicker.toggle()
                }) {
                    Text("Upload Photo")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding().frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.04)
                        .background(themes.blackButtonColor)
                        .cornerRadius(15)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .fullScreenCover(isPresented: $showingImagePreview) {
                    ImagePreviewView(image: $image, inputImage: $inputImage,showingImagePreview: $showingImagePreview)
                }
                .onChange(of: inputImage) { _ in changeView()}
            }
            
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    

    
    func changeView() {
        guard inputImage != nil else { return }
        showingImagePreview = true

    }
    
}

struct ImagePreviewView: View {
    
    @Binding var image: Image?
    @Binding var inputImage: UIImage?
    @Binding var showingImagePreview: Bool
    @State var caption = ""
    var themes = Themes()
    var db = DatabaseModel()
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        showingImagePreview = false
                    }) {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.4)
                    .cornerRadius(20)
                    .padding()
                
                Divider()
                
                CustomTextEditor(placeholder: "Write a caption..", caption: $caption)
                    .lineLimit(4)
                    .frame(width: UIScreen.main.bounds.width * 0.90,height: 150)

                    
                Divider()
                
                Button(action: {
                    uploadPost()
                }) {
                    Text("Post")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                        .background(themes.blackButtonColor)
                        .cornerRadius(15)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
                }
                
                
                Spacer()
            }
            
            
        }.onAppear {
            loadImage()
        }
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)

    }
    
    func uploadPost() {
        guard inputImage != nil else { return }

        db.makePost(image: inputImage, caption: caption)
        showingImagePreview = false
        
    }
    
}

struct CustomTextEditor: View {
    let placeholder: String
    @Binding var caption: String
    var body: some View {
        ZStack(alignment: .topLeading) {
            if caption.isEmpty  {
                Text(placeholder)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(EdgeInsets(top: 7, leading: 4, bottom: 0, trailing: 0))
                    .padding(5)
            }
            TextEditor(text: $caption)
                .padding(5)
        }.onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }.onDisappear() {
            UITextView.appearance().backgroundColor = nil
        }
    }
}


struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
