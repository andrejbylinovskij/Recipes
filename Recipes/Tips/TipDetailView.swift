//
//  TipDetailView.swift
//  Recipes
//
//  Created by D K on 11.11.2024.
//

import SwiftUI

struct TipDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var tip: Tip
    
    var body: some View {
        ZStack {
            Image("bg4")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 9)
            
            VStack {
                ScrollView {
                    Image(tip.imagePrompt)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size().width, height: 300)
                        .clipped()
                    VStack {
                        Text(tip.tip)
                            .font(.system(size: 30, weight: .light))
                            .frame(width: size().width - 20, alignment: .leading)
                        
                        Text(tip.description)
                            .padding(.horizontal, 10)
                            .font(.system(size: 24, weight: .light))
                            .frame(width: size().width)
                            
                            .padding(.top, 10)
                            .padding(.bottom, 50)
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .offset(y: -20)
               
                }
                .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .black))
                            .shadow(radius: 10)
                    }
                    
                    Spacer()
                }
               Spacer()
            }
            .padding(.top)
            .padding(.leading)
        }
    }
}

