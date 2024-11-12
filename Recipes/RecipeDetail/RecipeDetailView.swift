//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isLiked = false
    var recipe: Recipe
    
    var body: some View {
        ZStack {
            Image("bg4")
                .resizable()
                .blur(radius: 4)
                .ignoresSafeArea()
            
            VStack {
                Image(recipe.id)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .cornerRadius(24)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            
            
            VStack {
                ScrollView {
                    VStack {

                        
                        Text(recipe.name)
                            .foregroundStyle(.white)
                            .font(.system(size: 38, weight: .black))
                            .shadow(radius: 1)
                            .frame(width: size().width - 40, alignment: .leading)
                            .padding(.top, 20)
                        
                        Text(recipe.description)
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .regular))
                            .frame(width: size().width - 40, alignment: .leading)
                            .padding(.top, 1)
                        
                        VStack(alignment: .leading) {
                            Text("Time to cook: \(recipe.cookingTime)")
                                .font(.system(size: 22, weight: .light))
                                .frame(width: size().width - 40, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            
                            
                            Text("Ingredients:")
                                .font(.system(size: 22, weight: .light))
                                .padding(.top, 10)
                                .foregroundColor(.black)
                            
                            VStack(alignment: .leading) {
                                ForEach(recipe.ingredients, id: \.self) { ingredient in
                                    Text("• \(ingredient)")
                                        .font(.system(size: 18, weight: .light))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.top, 10)
                        }
                        .frame(width: size().width - 40, alignment: .leading)
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)
                                                    
                        
                        Text("Cooking Steps:")
                            .font(.system(size: 38, weight: .black))
                            .foregroundColor(.white)
                            .shadow(radius: 1)
                            .frame(width: size().width - 40, alignment: .leading)
                            .padding(.vertical, 5)
                        
                        
                        VStack {
                            ForEach(recipe.cookingSteps, id: \.self) { step in
                                
                                HStack {
                                    Text(removeStartTimer(from: step))
                                        .font(.system(size: 18, weight: .light))
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 26)
                                        .foregroundColor(.white)
                                }
                                .shadow(radius: 10)
                                .padding(.horizontal, 20)
                                
                            }
                        }
                    }
                    .background {
                        Rectangle()
                            .fill(LinearGradient(colors: [.semiOrange, .lightOrange], startPoint: .top, endPoint: .bottom))
                            
                          //  .frame(width: size().width - 40, height: 350)
                            .cornerRadius(36)
                    }
                    .padding(.top, 270)
                }
                .scrollIndicators(.hidden)
               
            }
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.lightOrange)
                    }
                    .shadow(color: .black, radius: 10)
                    
                    Spacer()
                    
                    Button {
                        StorageManager.shared.toggleRecipeLike(recipe: recipe)
                        isLiked.toggle()
                    } label: {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 32))
                            .foregroundColor(isLiked ? .lightOrange : .gray)
                    }
                    .shadow(color: .black, radius: 10)
                }
                .padding(.top)
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
        .onAppear {
            isLiked = StorageManager.shared.isRecipeLiked(recipe: recipe)
        }
        
    }
    
    func removeStartTimer(from input: String) -> String {
        return input.replacingOccurrences(of: "StartTimer", with: "")
    }
}

#Preview {
    RecipeDetailView(recipe: .MOCK)
}
