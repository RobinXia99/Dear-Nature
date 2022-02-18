//
//  SignUpStack.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-21.
//

import SwiftUI

struct SignUpStack: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var fullName: String = ""
    var theme = Themes()

    
    var body: some View {
        
        
            TextField("Full Name", text: $fullName)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .cornerRadius(15)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(theme.textFieldGrey!, lineWidth: 1)
                            .shadow(radius: 1)
                    }
                }
                .autocapitalization(.none)
                .padding(.bottom,15).padding(.top,20)
            

            TextField("E-mail", text: $email)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .cornerRadius(15)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(theme.textFieldGrey!, lineWidth: 1)
                            .shadow(radius: 1)
                    }
                }
                .autocapitalization(.none)
                .padding(.bottom,15)
            
            
            
            SecureField("Password", text: $password)
                .foregroundColor(.black)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
                .background(.white)
                .cornerRadius(15)
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(theme.textFieldGrey!, lineWidth: 1)
                            .shadow(radius: 1)
                    }
                }
                .autocapitalization(.none)
                .padding(.bottom,15)
            
            
            Button(action: {
                authHandler.signUp(email: email, password: password, fullName: fullName)

            }, label: {
                Text("Sign Up")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                    .background(theme.pinkTheme)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
            })
        

            Text("or")
                .font(.callout)
                .underline()
                .foregroundColor(.black)
                .padding(20)
        
        
        Button(action: {
            authHandler.googleSignIn()
        }, label: {
            Text("Continue with Google")
                .font(.title3)
                .foregroundColor(.white)
                .padding()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06).background(.green)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
        })
            
        }
    }

