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
    let blue = Color("#3066A5")
    let green = Color("#27AF22")
    
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
                
                Group {
                    Text("LOGO / APPNAME")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                
                CustomDivider()
                
                LoginStack()
                
                
                Group {
                    Button(action: {
                        authHandler.googleSignIn()
                    }, label: {
                        
                        Text("Continue with Google")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06).background(green)
                            .cornerRadius(25)
                    })
                    
                    CustomDivider()
                    
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Forgot Password?")
                            .font(.title3)
                            .underline()
                            .foregroundColor(.white)
                    }).padding(.bottom,40)
                    
                    
                    Button(action: {
                        isShowingSheet.toggle()
                    }, label: {
                        Text("Create Account")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                            .background(blue)
                            .cornerRadius(25)
                        
                        
                    }).sheet(isPresented: $isShowingSheet) {
                        SignUpView(isShowingSheet: $isShowingSheet)
                    }

                }
                
                Spacer()
                
                
                
                
                
            }
        }
        
        
        
        
        
        
        
        
        
        
    }
}


struct LoginStack: View {
    @EnvironmentObject var authHandler: AuthViewModel
    
    let blue = Color("#3066A5")
    let green = Color("#27AF22")
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        
        
        
        TextField("E-mail", text: $email)
            .foregroundColor(.black)
            .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
            .background(.white)
            .cornerRadius(25)
            .autocapitalization(.none)
        
        
        
        SecureField("Password", text: $password)
            .foregroundColor(.black)
            .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.056)
            .background(.white)
            .cornerRadius(25)
            .autocapitalization(.none)
        
        
        Button(action: {
            authHandler.signIn(email: email, password: password)
        }, label: {
            Text("Sign In")
                .font(.title3)
                .foregroundColor(.white)
                .padding().frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.06)
                .background(blue)
                .cornerRadius(25)
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
            .cornerRadius(1)
            .edgesIgnoringSafeArea(.horizontal)
            .padding()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



