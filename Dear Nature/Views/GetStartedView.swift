//
//  GetStartedView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-25.
//

import SwiftUI

struct GetStartedView: View {
    
    var theme = Themes()
    @EnvironmentObject var authHandler: AuthViewModel
    @Binding var isNewUser: Bool
    
    var body: some View {
        ZStack {
            VStack {
                LinearGradient(gradient: theme.blueGradient, startPoint: .top, endPoint: .bottom).frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.75).cornerRadius(15).shadow(color: .black, radius: 4, x: 0, y: 2).overlay {
                    
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
                        
                        
                        
                        SelectPhotoView()
                            .padding()
                        
                        CustomDivider()
                        
                        SelectUsernameView()
                        
                        Spacer()
                    }
                    
                }
                .padding()
                
                Button(action: {
                    isNewUser = false
                }, label: {
                    Text("Continue")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding().frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.056)
                        .background(theme.blackButtonColor)
                        .cornerRadius(20)
                        .shadow(color: .black, radius: 2, x: 0, y: 2)
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
    
}

struct SelectPhotoView: View {
    var theme = Themes()
    var selectedImage = "white"
    var body: some View {
        VStack {
            Text("Profile Picture")
                .font(.title)
                .foregroundColor(.white)
            
            Image(selectedImage)
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -3)
                .padding(.bottom,10)
            
            Button(action: {
                
            }, label: {
                Text("Select Photo")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding().frame(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.04)
                    .background(theme.blackButtonColor)
                    .cornerRadius(15)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)
            })
        }
        
        
    }
}

struct SelectUsernameView: View {
    @State var username = ""
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
                .padding().frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -3)
                .cornerRadius(20)
                .autocapitalization(.none)
            
            
        }
    }
}

struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView(isNewUser: .constant(false))
    }
}
