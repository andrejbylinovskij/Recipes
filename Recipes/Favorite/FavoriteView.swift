//
//  FavoriteView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct FavoriteView: View {
    
    @State private var favorites: [RealmRecipe] = []
    @State private var recipes: [Recipe] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg3")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        StrokeText(text: "Favorites", width: 1, borderColor: .black, mainColor: .white)
                            .font(.system(size: 38, weight: .black))
                            .foregroundColor(.black)
                            .shadow(radius: 1)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                                        
                    ScrollView {
                        VStack {
                            ForEach(favorites, id: \.id) { recipe in
                                NavigationLink {
                                    if let rec = findRecipeById(recipes: recipes, id: recipe.recipeId) {
                                        RecipeDetailView(recipe: rec)
                                            .navigationBarBackButtonHidden()
                                    }
                                } label: {
                                    Image(recipe.recipeId)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: size().width - 50, height: 200)
                                        .cornerRadius(24)
                                        .shadow(radius: 5)
                                        .overlay {
                                            VStack {
                                                Spacer()
                                                
                                                HStack {
                                                    Text(recipe.name)
                                                        .font(.system(size: 20, weight: .black))
                                                        .foregroundColor(.black)
                                                        .padding(10)
                                                        .frame(width: size().width - 50)
                                                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.lightOrange))
                                                        .multilineTextAlignment(.leading)
                                                    
                                                    Spacer()
                                                }
                                            }
                                            .offset(y: 15)
                                        }
                                }
                                
                                
                            }
                        }
                        .padding(.bottom, 200)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .onAppear {
            recipes = parseMenu() ?? []
            favorites = Array(StorageManager.shared.recipes)
            
        }
    }
    
    func parseMenu() -> [Recipe]? {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json") else {
            print("not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let menuItems = try JSONDecoder().decode([Recipe].self, from: data)
            return menuItems
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
    
    func findRecipeById(recipes: [Recipe], id: String) -> Recipe? {
        return recipes.first { $0.id == id }
    }
}

#Preview {
    FavoriteView()
}
