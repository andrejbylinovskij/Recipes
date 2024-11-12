//
//  RealmRecipe.swift
//  Recipes
//
//  Created by D K on 11.11.2024.
//

import Foundation
import RealmSwift

class RealmRecipe: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var recipeId: String
    
    @Persisted var name: String
    @Persisted var image: String
    
    @Persisted var recipeDescription: String
    @Persisted var cookingTime: String
    @Persisted var servings: String
    
    @Persisted var ingredients: List<String>
    @Persisted var cookingSteps: List<String>
}
