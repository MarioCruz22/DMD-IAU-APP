//
//  WelcomeScreenView.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

struct WelcomeScreenView: View {
    var body: some View {
        TabView {
                Text("Favourites Screen")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                }
                CameraView()
                    .tabItem {
                        Image(systemName: "camera.fill")
                        Text("Camera")
                }
                //Text("Nearby Screen")
//            DisplayView()
            DetectionsScreenView()
                    .tabItem {
                        Image(systemName: "eye.fill")
                        Text("D2Go")
                }
            }
    }
}
