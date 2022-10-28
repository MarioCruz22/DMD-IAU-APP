//
//  loginApp.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

@main
struct loginApp: App {
    @StateObject var authentication = Authentication()
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                WelcomeScreenView()
                    .environmentObject(authentication)
            } else {
                SignInScreenView()
                    .environmentObject(authentication)
            }
        }
    }
}
