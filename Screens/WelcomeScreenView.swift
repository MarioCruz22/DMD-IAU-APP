//
//  WelcomeScreenView.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

struct WelcomeScreenView: View {
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        TabView {
                ImagePickerView()
                .environmentObject(authentication)
                .environmentObject(ImagePickerViewModel())
                .environmentObject(LoginViewModel())
                    .onAppear{
                        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    }
                    .tabItem {
                        Label ("ImagePicker", systemImage: "photo.fill")
                    }

            DetectionsScreenView()
                    .tabItem {
                        Label ("D2Go", systemImage: "eye.fill")
                }
            ARView_Tree()
                .tabItem {
                    Label ("AR", systemImage: "sun.max.fill")
                }
            ARJSWebView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("ARJS")
                    //Label ("ARJS", systemImage: "leaf.fill")
                }
        }.accentColor(Color("PrimaryColor"))
    }
}
