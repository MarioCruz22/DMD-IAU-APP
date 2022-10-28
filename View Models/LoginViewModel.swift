//
//  LoginViewModel.swift
//  SwiftClient
//
//  Created by Mohammad Azam on 4/14/21.
//

import Foundation

class LoginViewModel: ObservableObject {
    fefe
    var username: String = ""
    var password: String = ""
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
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func signout() {
           
           let defaults = UserDefaults.standard
           defaults.removeObject(forKey: "jsonwebtoken")
           DispatchQueue.main.async {
               self.isAuthenticated = false
           }
           
       }
    
}
