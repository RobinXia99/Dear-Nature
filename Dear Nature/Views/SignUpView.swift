//
//  SignUpView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-21.
//

import SwiftUI

struct SignUpView: View {

    @EnvironmentObject var authHandler: AuthViewModel
    
    let green = Color("#27AF22")
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        
        ZStack {
            
            Image("flowers")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                .overlay(Color(.black)
                            .opacity(0.33))
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("Create Account")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                CustomDivider()
                
                SignUpForms(isShowingSheet: $isShowingSheet)
                
                
                CustomDivider()
                
                Button(action: {
                    authHandler.googleSignIn()
                }, label: {
                    Text("Continue with Google")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06).background(green)
                        .cornerRadius(50)
                })
                
                Spacer()
                
                
            }
            
        }
        
    }
}

struct SignUpForms: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    @Binding var isShowingSheet: Bool
    
    
    let blue = Color("#3066A5")
    
    var body: some View {
        
        
            TextField("Full Name", text: $fullName)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .cornerRadius(50)
                .autocapitalization(.none)
            

            TextField("E-mail", text: $email)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .cornerRadius(50)
                .autocapitalization(.none)
            
            
            
            SecureField("Password", text: $password)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .cornerRadius(50)
                .autocapitalization(.none)
            
            
            Button(action: {
                authHandler.signUp(email: email, password: password, fullName: fullName) { completion in
                    if completion {
                        isShowingSheet = false
                    } else {
                        print("Error signing up")
                    }
                }

            }, label: {
                Text("Sign Up")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                    .background(blue)
                    .cornerRadius(50)
            })
            
        }
    }


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(isShowingSheet: .constant(false))
    }
}
