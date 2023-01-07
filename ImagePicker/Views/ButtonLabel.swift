//
//  ButtonLabel.swift
//  login
//
//  Created by pedro on 12/30/22.
//

import SwiftUI

struct ButtonLabel: View {
    let symbolName: String
    let label: String
    var body: some View {
        HStack {
            Image(systemName: symbolName)
            Text(label)
        }
        .font(.headline)
        .padding()
        .frame(height: 40)
        .background(Color("PrimaryColor"))
        .foregroundColor(.white)
        .cornerRadius(15)
    }
}
