//
//  Recipe.swift
//  Recipes
//
//  Created by D K on 06.11.2024.
//

import Foundation


class Recipe: Codable {
    
    var id: String
    var name: String
    var image: String
    
    var description: String
    var cookingTime: String
    var servings: String
    
    var ingredients: [String]
    var cookingSteps: [String]
    
    init(id: String, name: String, image: String, description: String, cookingTime: String, servings: String, ingredients: [String], cookingSteps: [String]) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.cookingTime = cookingTime
        self.servings = servings
        self.ingredients = ingredients
        self.cookingSteps = cookingSteps
    }
}

extension Recipe {
    static let MOCK = Recipe(id: "1", name: "Classic Tiramisu", image: "Classic Tiramisu", description: "Indulge in this iconic Italian dessert with layers of espresso-soaked ladyfingers, rich mascarpone, and a hint of cocoa. This Tiramisu is creamy, luxurious, and perfect for any special occasion.", cookingTime: "30 minutes", servings: "6 servings", 
                             ingredients: ["Ladyfingers 200g", "Mascarpone cheese 250g", "Heavy cream 120ml", "Sugar 100g", "Egg yolks 4", "Espresso coffee 1 cup", "Cocoa powder for dusting"],
                             cookingSteps: ["Step 1: Brew the espresso and let it cool. Set aside.", "Step 2: In a bowl, whisk egg yolks and sugar until light and creamy.", "Step 3: Add mascarpone to the egg mixture and fold gently to combine.", "Step 4: In a separate bowl, whip the cream until stiff peaks form and fold into the mascarpone mixture.", "Step 5: Dip each ladyfinger briefly in espresso, then layer in a dish.", "Step 6: Spread half of the mascarpone mixture over the ladyfingers.", "Step 7: Repeat with another layer of ladyfingers and mascarpone.", "Step 8: Dust the top with cocoa powder and refrigerate for 4 hours before serving. StartTimer" ])
}
