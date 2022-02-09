//
//  ContentView.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-18.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authHandler: AuthViewModel
    
    
    var body: some View {
        Group {
            ZStack {
                if !authHandler.isSignedIn {
                    LoginView()
                } else {
                    TabsView()
                }
            }
        }.onAppear(perform: getUser)
        
    }
    
    func getUser() {
        authHandler.listenToUserChanges()
    }
    
    
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authHandler = AuthViewModel()
        ContentView()
            .environmentObject(authHandler)
        
    }
}

