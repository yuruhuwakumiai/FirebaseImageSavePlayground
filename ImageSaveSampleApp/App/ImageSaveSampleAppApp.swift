//
//  ImageSaveSampleAppApp.swift
//  ImageSaveSampleApp
//
//  Created by 橋元雄太郎 on 2023/12/07.
//

import SwiftUI

@main
struct MyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ImageUploadView()
        }
    }
}
