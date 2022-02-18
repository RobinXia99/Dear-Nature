//
//  Login.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    @State private var isShowingSheet = false
    @State var pickerSelection = "Login"
    var theme = Themes()
    
    var body: some View {
        
        
        ZStack {
            VStack {
                Image("loginlogo")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height * 0.45)
                    .ignoresSafeArea()
                Spacer()
            }
            
            
            VStack {

                HStack {
                    Text(pickerSelection)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                }.padding(.leading).padding(.top,100)
                
                
                Picker("", selection: $pickerSelection) {
                    Text("Login")
                        .tag("Login")
                    Text("Create Account")
                        .tag("Create Account")
                }.pickerStyle(SegmentedPickerStyle()).padding(.horizontal,10)
                CustomDivider()
                
                VStack {
                    if pickerSelection == "Login" {
                        LoginStack()
                    } else {
                        SignUpStack()
     
                    }
                    Spacer()
                }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)
                
            }
        }
        
        
        
        
        
        
        
        
        
        
    }
}


struct LoginStack: View {
    @EnvironmentObject var authHandler: AuthViewModel
    
    var theme = Themes()
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        
        
        
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
            .padding(.bottom,15).padding(.top,20)
        
        
        
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
            authHandler.signIn(email: email, password: password)
        }, label: {
            Text("Sign In")
                .font(.title3)
                .foregroundColor(.white)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                .background(theme.pinkTheme)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
        })
        
        Button(action: {
            
        }, label: {
            Text("Forgot Password?")
                .font(.callout)
                .underline()
                .foregroundColor(.black)
        }).padding(25)
        
        
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

struct CustomDivider: View {
    let color: Color = .white
    let thickness: CGFloat = 2
    var body: some View {
        
        Rectangle()
            .fill(color)
            .frame(width: UIScreen.main.bounds.width * 0.9,height: thickness)
            .cornerRadius(2)
            .edgesIgnoringSafeArea(.horizontal)
            .padding(.horizontal)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



