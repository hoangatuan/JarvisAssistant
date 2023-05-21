//
//  JarvisApp.swift
//  Jarvis
//
//  Created by Tuan Hoang on 15/05/2023.
//

import SwiftUI

@main
struct JarvisApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                    }

                GalleryView()
                    .tabItem {
                        Image(systemName: "2.square.fill")
                    }
            }
        }
    }

}

