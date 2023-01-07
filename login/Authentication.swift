//
//  Authentication.swift
//  login
//
//  Created by formando on 26/10/2022.
//

import SwiftUI

class Authentication: ObservableObject {
    @Published var isValidated = DeepVision.KeychainHelper.standard.read(service: "token",
                                                                    account: "DeepVision",
                                                                    type: String.self) != nil

    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Either your email or password are incorrect. Please try again", comment: "")
            }
        }
    }
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    
}
