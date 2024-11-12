//
//  RegView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct RegView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @State private var isNotificationShown = false
    @State private var switched = true
    @State private var isAlerted = false
    
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg2")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("exitIcon")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Rectangle()
                        .fill(LinearGradient(colors: [.semiOrange, .lightOrange], startPoint: .leading, endPoint: .trailing))
                        .opacity(0.7)
                        .frame(width: size().width - 60, height: 380)
                        .cornerRadius(36)
                        .overlay {
                            VStack {
                                TextField("", text: $email, prompt: Text("E-Mail"))
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 24)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                
                                TextField("", text: $password, prompt: Text("Password"))
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 24)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal)
                                
                                TextField("", text: $passwordConfirm, prompt: Text("Confirm password"))
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 24)
                                            .foregroundColor(.white)
                                    }
                                    .padding()
                                
                                Button {
                                    if isValid {
                                        Task {
                                            try await viewModel.createUser(withEmail: email, password: password)
                                        }
                                        withAnimation {
                                            isAlerted.toggle()
                                        }
                                    } else {
                                        withAnimation {
                                            isAlerted.toggle()
                                        }
                                        isNotificationShown.toggle()
                                    }
                                } label: {
                                    Text("Registration")
                                        .font(.system(size: 28, weight: .black))
                                        .foregroundColor(.semiOrange)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 15)
                                        .background {
                                            RoundedRectangle(cornerRadius: 36)
                                                .foregroundColor(.white)
                                        }
                                }
                                .padding(.top)
                            }
                        }
                        .padding(.top, 50)
                        
                    
                    Spacer()
                }
            }
        }
        .overlay {
            if isAlerted {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.white.opacity(0.1))
                    
                    if switched {
                        Rectangle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white.opacity(0.9))
                            .blur(radius: 5)
                            .cornerRadius(24)
                            .shadow(color: .white.opacity(0.5), radius: 5)
                            .overlay {
                                ProgressView()
                                    .tint(.orange)
                                    .controlSize(.large)
                            }
                    } else {
                        Rectangle()
                            .frame(width: 290, height: 250)
                            .foregroundColor(.white.opacity(0.9))
                            .blur(radius: 5)
                            .cornerRadius(24)
                            .shadow(color: .white.opacity(0.5), radius: 5)
                            .overlay {
                                VStack {
                                    Text("Incorrect data or user with this email already exists.")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 24, weight: .semibold, design: .monospaced))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Button {
                                        withAnimation {
                                            isAlerted = false
                                            switched = true
                                            
                                            email = ""
                                            password = ""
                                            passwordConfirm = ""
                                        }
                                    } label: {
                                       Image(systemName: "xmark")
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.black)
                                            .bold()
                                    }
                                    .padding(.top, 30)
                                }
                               
                            }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        switched = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    RegView()
//}

extension RegView: AuthViewModelProtocol {
    var isValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && passwordConfirm == password
    }
}
