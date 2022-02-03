//
// AppDelegate.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-01-28.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        //appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor(red: 60/256, green: 166/256, blue: 211/256, alpha: 1)
        
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        //appearance.largeTitleTextAttributes = attrs
        appearance.titleTextAttributes = attrs
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        return true
    }
}
