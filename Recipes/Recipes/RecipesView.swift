//
//  RecipesView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct RecipesView: View {
    
    @State private var searchText = ""
    @State private var recipes: [Recipe] = []
    @State private var filteredRecipes: [Recipe] = []
    @State private var isSettingsShown = false
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150, maximum: 250))
    ]
    private let debounceDelay = 0.3
    private let filterbuttons: [String] = ["All", "cake", "apple", "choco", "raspberry", "lemon"]
    @State private var selectedFilter = "All"
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg3")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        StrokeText(text: "Recipes", width: 1, borderColor: .black, mainColor: .white)
                            .font(.system(size: 38, weight: .black))
                            .foregroundColor(.black)
                            .shadow(radius: 1)
                        
                        Spacer()
                        
                        Button {
                            isSettingsShown.toggle()
                        } label: {
                            Image("gears")
                                .resizable()
                                .frame(width: 29, height: 29)
                        }
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        
                        TextField("", text: $searchText, prompt: Text("🔍 Search..."))
                            .tint(.black)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 24)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                            .onChange(of: searchText) { newValue in
                                selectedFilter = "All"
                                 performSearch(with: newValue)
                            }
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(filterbuttons, id: \.self) { text in
                                    Button {
                                        
                                      // searchText = ""
                                        withAnimation {
                                            selectedFilter = text
                                            filteredRecipes = searchRecipes(with: text, in: recipes)
                                        }
                                        
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(width: 100, height: 50)
                                                .foregroundColor(selectedFilter == text ? .semiOrange : .white)
                                                .shadow(radius: 1, y: 1)
                                                .padding(1)
                                            
                                            Text(text.capitalized)
                                                .foregroundStyle(.black)
                                        }
                                    }
//                                    .onChange(of: selectedFilter) { newValue in
//                                        withAnimation {
//                                            if selectedFilter == "All" {
//                                                filteredRecipes = recipes
//                                            } else {
//                                                filteredRecipes = searchRecipes(with: text, in: recipes)
//
//                                            }
//                                        }
//                                    }
                                }
                            }
                            .padding(.leading)
                            .padding(.top)
                        }
                        .scrollIndicators(.hidden)
                        
                        
                        LazyVGrid(columns: adaptiveColumn, spacing: 40) {
                            ForEach(filteredRecipes, id: \.id) { type in
                                NavigationLink {
                                    RecipeDetailView(recipe: type).navigationBarBackButtonHidden()
                                } label: {
                                    Image(type.id)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 170, height: 180)
                                        .cornerRadius(24)
                                        .shadow(radius: 5)
                                        .overlay {
                                            VStack {
                                                Spacer()
                                                
                                                HStack {
                                                    Text(type.name)
                                                        .font(.system(size: 14, weight: .black))
                                                        .foregroundColor(.black)
                                                        .padding(10)
                                                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.lightOrange))
                                                        .multilineTextAlignment(.leading)
                                                    Spacer()
                                                }
                                            }
                                            .offset(y: 25)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .scrollIndicators(.hidden)
                   // .padding(.top)
                }
            }
        }
        .onAppear {
            recipes = parseMenu() ?? []
            filteredRecipes = recipes
        }
        .fullScreenCover(isPresented: $isSettingsShown) {
            SettingsView().environmentObject(authViewModel)
        }
    }
    
    func searchRecipes(with query: String, in recipes: [Recipe]) -> [Recipe] {
        return recipes.filter { recipe in
            let lowercasedQuery = query.lowercased()
            
            return recipe.id.lowercased().contains(lowercasedQuery) ||
            recipe.name.lowercased().contains(lowercasedQuery) ||
            recipe.image.lowercased().contains(lowercasedQuery) ||
            recipe.description.lowercased().contains(lowercasedQuery) ||
            recipe.cookingTime.lowercased().contains(lowercasedQuery) ||
            recipe.servings.lowercased().contains(lowercasedQuery) ||
            recipe.ingredients.contains { $0.lowercased().contains(lowercasedQuery) } ||
            recipe.cookingSteps.contains { $0.lowercased().contains(lowercasedQuery) }
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
    
    private func performSearch(with text: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay) {
            withAnimation {
                if text == searchText {
                    filteredRecipes = recipes.filter { $0.name.localizedCaseInsensitiveContains(text) }
                }
                
                if searchText.isEmpty {
                    filteredRecipes = recipes
                }
            }
        }
    }
}

#Preview {
    RecipesView()
        .environmentObject(AuthViewModel())
}


struct StrokeText: View {
    let text: String
    let width: CGFloat
    let borderColor: Color
    let mainColor: Color
    
    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(borderColor)
            Text(text)
                .foregroundColor(mainColor)
        }
    }
}
