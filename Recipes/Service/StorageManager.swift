//
//  StorageManager.swift
//  Recipes
//
//  Created by D K on 11.11.2024.
//

import Foundation
import RealmSwift


class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    @ObservedResults(RealmRecipe.self) var recipes
    
    
    
    func toggleRecipeLike(recipe: Recipe) {

        // Пытаемся найти рецепт по ID
        if let existingRecipe = realm.objects(RealmRecipe.self).filter("recipeId == %@", recipe.id).first {
            // Если рецепт уже есть, удаляем его
            try! realm.write {
                realm.delete(existingRecipe)
            }
        } else {
            // Если рецепт отсутствует, добавляем его
            let realmRecipe = RealmRecipe()
            realmRecipe.recipeId = recipe.id
            realmRecipe.name = recipe.name
            realmRecipe.image = recipe.image
            realmRecipe.recipeDescription = recipe.description
            realmRecipe.cookingTime = recipe.cookingTime
            realmRecipe.servings = recipe.servings
            realmRecipe.ingredients.append(objectsIn: recipe.ingredients)
            realmRecipe.cookingSteps.append(objectsIn: recipe.cookingSteps)

            try! realm.write {
                realm.add(realmRecipe)
            }
        }
    }
    
    
    func isRecipeLiked(recipe: Recipe) -> Bool {
        return realm.objects(RealmRecipe.self).filter("recipeId == %@", recipe.id).first != nil
    }
}
