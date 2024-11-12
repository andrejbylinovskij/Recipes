//
//  SettingsView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI
import MessageUI
import StoreKit

struct SettingsView: View {
    
    @State var isAlertShown = false
    @State var isSuggestionShown = false
    @State var isErrorShown = false
    @State private var isDeleteAlertShown = false

    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image("bg2")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    StrokeText(text: "Settings", width: 1, borderColor: .black, mainColor: .white)
                        .font(.system(size: 38, weight: .black))
                        .foregroundColor(.black)
                        .shadow(radius: 1)
                }
                .padding(.horizontal)
                .padding(.top, 6)
                
                ScrollView {
                    Button {
                        if MFMailComposeViewController.canSendMail() {
                            isErrorShown.toggle()
                        } else {
                            isAlertShown.toggle()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 36)
                                .foregroundColor(.white)
                                .frame(height: 80)
                                .padding(1)
                                .shadow(radius: 1)
                            
                            Text("Feedback")
                                .font(.system(size: 20, weight: .black))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 40)
                    .sheet(isPresented: $isErrorShown) {
                        MailComposeView(isShowing: $isErrorShown, subject: "Feedback", recipientEmail: "pinaroymacii@icloud.com", textBody: "")
                    }
                    
                    Button {
                        openPrivacyPolicy()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 36)
                                .foregroundColor(.white)
                                .frame(height: 80)
                                .padding(1)
                                .shadow(radius: 1)
                            
                            Text("Privacy Policy")
                                .font(.system(size: 20, weight: .black))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Button {
                        requestAppReview()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 36)
                                .foregroundColor(.white)
                                .frame(height: 80)
                                .padding(1)
                                .shadow(radius: 1)
                            
                            Text("Rate The App 🧡")
                                .font(.system(size: 20, weight: .black))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Button {
                        authViewModel.signOut()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 36)
                                .foregroundColor(.white)
                                .frame(height: 70)
                                .padding(1)
                                .shadow(radius: 1)
                            
                            Text("Sign Out")
                                .font(.system(size: 26, weight: .black))
                                .foregroundStyle(Color.semiOrange)
                        }
                    }
                    .padding(.horizontal, 100)
                    .padding(.top, 100)
                    
                    if authViewModel.currentuser != nil {
                        Button {
                            isDeleteAlertShown.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 36)
                                    .foregroundColor(.semiOrange)
                                    .frame(height: 50)
                                    .padding(1)
                                    .shadow(radius: 1)
                                
                                Text("Delete account")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding(.horizontal, 100)
                    }
                }
            }
            
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("exitIcon")
                            .resizable()
                            .frame(width: 35, height: 30)
                    }
                    
                    Spacer()
             
                }
                .padding(.top)
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .alert("Are you sure you want to delete your account?", isPresented: $isDeleteAlertShown) {
            Button {
                authViewModel.deleteUserAccount { result in
                    switch result {
                    case .success():
                        print("Account deleted successfully.")
                        authViewModel.userSession = nil
                        authViewModel.currentuser = nil
                    case .failure(let error):
                        print("ERROR DELELETING: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("Yes")
            }
            
            Button {
                isDeleteAlertShown.toggle()
            } label: {
                Text("No")
            }
        } message: {
            Text("To access your reserves you will need to create a new account.")
        }
        .alert("Unable to send email", isPresented: $isAlertShown) {
            Button {
                isAlertShown.toggle()
            } label: {
                Text("Ok")
            }
        } message: {
            Text("Your device does not have a mail client configured. Please configure your mail or contact support on our website.")
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://sites.google.com/view/yummmybook/privacy-policy") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}


struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    let subject: String
    let recipientEmail: String
    let textBody: String
    var onComplete: ((MFMailComposeResult, Error?) -> Void)?
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.setSubject(subject)
        mailComposer.setToRecipients([recipientEmail])
        mailComposer.setMessageBody(textBody, isHTML: false)
        mailComposer.mailComposeDelegate = context.coordinator
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isShowing = false
            parent.onComplete?(result, error)
        }
    }
}
