//
//  DetectionsScreenView.swift
//  login
//
//  Created by pedro on 12/2/22.
//

import SwiftUI
import UIKit

struct DetectionsScreenView: View {
    var body: some View {
        storyBoardView().edgesIgnoringSafeArea(.all)
    }
}

struct DetectionsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DetectionsScreenView()
    }
}
	
struct storyBoardView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Detections")
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
