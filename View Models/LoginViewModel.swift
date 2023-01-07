//
//  LoginViewModel.swift
//  SwiftClient
//
//  Created by Mohammad Azam on 4/14/21.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var invalidCredentials: Bool = false
    @Published var showProgressView = false
    @Published var isAuthenticated: Bool = false
    
    func login(completion: @escaping (Bool) -> Void) {
        self.showProgressView = true
        let defaults = UserDefaults.standard
        
        Webservice().login(username: username, password: password) { result in
            self.showProgressView = false
            switch result {
            case .success(let token):
                defaults.setValue(token, forKey: "jsonwebtoken")
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    completion(true)
                    KeychainHelper.standard.save(token, service: "token", account: "DeepVision")
                }
            case .failure(let error):
                // defaults.removeObject(forKey: "jsonwebtoken")
                self.invalidCredentials = true
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func signout(completion: @escaping (Bool) -> Void) {
        print("Logging out")
        KeychainHelper.standard.delete(service: "token", account: "DeepVision")
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jsonwebtoken")
        DispatchQueue.main.async {
            self.isAuthenticated = false
            completion(false)
        }
        
    }
    
}
