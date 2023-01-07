//
//  ARJSWebView.swift
//  login
//
//  Created by pedro on 12/30/22.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url:URL
    
    func makeUIView(context: Context) -> some UIView {
        let webview = WKWebView()
        let request = URLRequest(url: url)
        webview.load(request)
        return webview
        
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    
    }
    
}

struct ARJSWebView: View {
    var body: some View {
        VStack {
            WebView(url: URL(string: "https://pfcouto.github.io/ar_fruits/")!)
        }
    }
}

struct ARJSWebView_Previews: PreviewProvider {
    static var previews: some View {
        ARJSWebView()
    }
}
