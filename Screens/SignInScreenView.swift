//
//  SignInScreenView.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

struct SignInScreenView: View {
    @StateObject var loginVM = LoginViewModel()
    @EnvironmentObject var authentication: Authentication
    @FocusState private var focus: Bool
    var body: some View {
        
        
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    
                    Image(uiImage: #imageLiteral(resourceName: "onboard"))
                    
                    
                    TextField("Username", text: $loginVM.username)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .focused($focus)
                    
                    SecureField("Password", text: $loginVM.password)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .focused($focus)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                    
                    Button {
                        focus = false
                        loginVM.login { success in
                            authentication.updateValidation(success: success)
                        }
                    } label: {
                        if loginVM.showProgressView {
                            ProgressView()
                        } else {
                            Text("Sign in")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryColor"))
                                .cornerRadius(50)
                        }
                    }
                    
                }
                
                Spacer()
                
                
                ZStack {
                    Divider()
                    Text("   Or   ")
                        .background(Color("BgColor"))
                }
                
                
                
                SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign in with Apple")).padding(.top)
                
                SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign in with Google"))
                
            }
            .padding()
        }
    }
}


struct PrimaryButton: View {
    var title: String
    var body: some View {
        
        Button {
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("PrimaryColor"))
                .cornerRadius(50)
        }
    }
}



struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenView()
    }
}


struct SocalLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.title2)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
    }
}
