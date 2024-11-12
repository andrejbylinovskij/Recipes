//
//  Tip.swift
//  Recipes
//
//  Created by D K on 11.11.2024.
//

import Foundation


class Tip: Codable {
    let tip, description, imagePrompt: String
    
    enum CodingKeys: String, CodingKey {
        case tip, description
        case imagePrompt = "image_prompt"
    }
    
    init(tip: String, description: String, imagePrompt: String) {
        self.tip = tip
        self.description = description
        self.imagePrompt = imagePrompt
    }
}
