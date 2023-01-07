//
//  SignInScreenView.swift
//  login
//
//  Created by Abu Anwar MD Abdullah on 23/4/21.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct SignInScreenView: View {
    @StateObject var loginVM = LoginViewModel()
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        
        
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack {
                    Text("Deep Vision")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    
                    Image(uiImage: #imageLiteral(resourceName: "deepvision"))
                        .resizable()
                        .frame(width: 400, height: 400)
                    
                    
                    TextField("", text: $loginVM.username, onEditingChanged: { x in print(loginVM.username)})
                        .placeholder(when: loginVM.username.isEmpty) {
                            Text("Username").foregroundColor(Color("PlaceholderColor"))
                        }
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .foregroundColor(Color.black)
                    
                    SecureField("", text: $loginVM.password)
                        .placeholder(when: loginVM.password.isEmpty) {
                            Text("Password").foregroundColor(Color("PlaceholderColor"))
                        }
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0, y: 16)
                        .foregroundColor(Color.black)
                    
                    Button {
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
                    }//.background(Color(red: 1, green: 152, blue: 183))
                    
                    
                    if loginVM.invalidCredentials {
                        if loginVM.username.isEmpty {
                            Text("Username Field is Empty.").foregroundColor(.red).font(.system(size: 20, weight: .semibold))
                        } else {
                            if loginVM.password.isEmpty {
                                Text("Password Field is Empty.").foregroundColor(.red).font(.system(size: 20, weight: .semibold))
                            } else {
                                Text("Invalid Credentials.").foregroundColor(.red).font(.system(size: 20, weight: .bold))
                            }
                        }
                        
                    
                    }
                    
                }
                
                Spacer()
                
                
                ZStack {
                    Divider()
                    Text("   Or   ")
                        .background(Color("BgColor"))
                }
                
                
                
                SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign in with Apple")).padding(.top).foregroundColor(Color.black)
                
                
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
