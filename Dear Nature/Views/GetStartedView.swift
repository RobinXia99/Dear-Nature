//
//  GetStartedView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-25.
//

import SwiftUI

struct GetStartedView: View {
    
    var theme = Themes()
    var db = DatabaseModel()
    @EnvironmentObject var authHandler: AuthViewModel
    @Binding var isNewUser: Bool
    @State var username = ""
    @State var image = Image("white")
    @State var inputImage: UIImage?
    
    var body: some View {
        ZStack {
            VStack {
                LinearGradient(gradient: theme.greenGradient, startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.75).cornerRadius(15).shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2).overlay {
                    
                    VStack {
                        Group {
                            Text("Welcome \(getFirstName())!")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding(.top,35)
                            
                            Text("Almost there!")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.bottom,15)
                        }
                        
                        
                        
                        SelectPhotoView(image: $image, inputImage: $inputImage)
                            .padding()
                        
                        CustomDivider()
                        
                        SelectUsernameView(username: $username)
                        
                        Spacer()
                    }
                    
                }
                .padding()
                
                Button(action: {
                    updateUserInfo()
                }, label: {
                    Text("Continue")
                        .font(.title3)
                        .foregroundColor(.black)
                        .padding().frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.056)
                        .background(.white)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                })
                    .padding()
            
            }
        }
        
        
    }
    
    func getFirstName() -> String {
        var firstName = ""
        
        if let fullName = authHandler.session?.fullName {
            let fullNameArr = fullName.components(separatedBy: " ")
            firstName = fullNameArr[0]
        }
        return firstName
    }
    
    func updateUserInfo() {
        guard authHandler.session != nil else {return}
        
        if let user = authHandler.session {
            if user.username == "" && username != "" {
                
                var newUser = user
                newUser.username = username
                print("user updating")
                db.createUserEntry(user: newUser) { result in
                    
                    if result == true {
                        
                        authHandler.session = newUser
                        print("user updated")
                        isNewUser = false
                        guard inputImage != nil else { return }
                        db.saveProfilePictureToFirebase(image: inputImage)
                        
                    }

                }
            }
        }
    }
    
    
}

struct SelectPhotoView: View {
    
    var theme = Themes()
    var db = DatabaseModel()
    @State var showingImagePicker: Bool = false
    @Binding var image: Image
    @Binding var inputImage: UIImage?
    
    
    var body: some View {
        VStack {
            Text("Profile Picture")
                .font(.title)
                .foregroundColor(.white)
            
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -3)
                .padding(.bottom,10)
            
            Button(action: {
                showingImagePicker = true
            }, label: {
                Text("Select Photo")
                    .font(.title3)
                    .foregroundColor(.black)
                    .padding().frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.042)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
            })
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in loadImage() }
        }
        
        
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)

    }
    
}

struct SelectUsernameView: View {
    @Binding var username: String
    var body: some View {
        VStack {
            Text("Username")
                .font(.title)
                .foregroundColor(.white)
            Text("Your username is your own unique identifier that will be linked to your account")
                .font(.body)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .multilineTextAlignment(.center)
            TextField("", text: $username)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.05)
                .background(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -1)
                .cornerRadius(15)
                .autocapitalization(.none)
            
            
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView(isNewUser: .constant(false))
    }
}
