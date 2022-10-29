//
//  MaroApp.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import SwiftUI

@main
struct MaroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
