//
//  LogInView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct LogInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var isAlertShown = false
    @State private var switcher = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    Rectangle()
                        .fill(LinearGradient(colors: [.semiOrange, .lightOrange], startPoint: .leading, endPoint: .trailing))
                        .opacity(0.7)
                        .frame(width: size().width - 60, height: 350)
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
                                
                                Button {
                                    Task {
                                        try await viewModel.signIn(email: email, password: password)
                                    }
                                    withAnimation {
                                        isAlertShown.toggle()
                                    }
                                } label: {
                                    Text("LOG IN")
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
                    
                    
                    Button {
                        Task {
                            await viewModel.signInAnonymously()
                        }
                        withAnimation {
                            isAlertShown.toggle()
                        }
                    } label: {
                        Text("Login without registration")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.semiOrange)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background {
                                RoundedRectangle(cornerRadius: 36)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                            }
                            .padding(.top, 20)
                    }
                    
                    NavigationLink {
                        RegView(viewModel: viewModel).navigationBarBackButtonHidden()
                    } label: {
                        Text("Registration")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.semiOrange)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background {
                                RoundedRectangle(cornerRadius: 36)
                                    .foregroundColor(.white)
                                    .shadow(radius: 1)
                            }
                            .padding(.top, 20)
                    }

                        
                }
            }
            .overlay {
                if isAlertShown {
                    ZStack {
                        Rectangle()
                            .ignoresSafeArea()
                            .foregroundColor(.white.opacity(0.1))
                        
                        if switcher {
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
                                        Text("Incorrect email or password.")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 24, weight: .semibold, design: .monospaced))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                        
                                        Button {
                                            withAnimation {
                                                isAlertShown = false
                                                switcher = true
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
                            switcher = false
                        }
                    }
                }
            }
        }
    }
}
