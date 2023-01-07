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
    
    init(){
        let token = DeepVision.KeychainHelper.standard.read(service: "token", account: "DeepVision", type: String.self)
        let defaults = UserDefaults.standard
        
        if(token != nil){
            defaults.setValue(token, forKey: "jsonwebtoken")
        }else{
            defaults.removeObject(forKey: "jsonwebtoken")
        }
        
    }
    
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
