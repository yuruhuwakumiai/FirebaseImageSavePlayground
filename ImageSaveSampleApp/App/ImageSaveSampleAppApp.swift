//
//  ImageSaveSampleAppApp.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/07.
//

import SwiftUI
import FirebaseCore
import FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ImageUploadView()
        }
    }
}
