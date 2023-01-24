//
//  WatchMirrorApp.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        _ = Connectivity.shared
        return true
    }
}

@main
struct WatchMirrorApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
    }
}
