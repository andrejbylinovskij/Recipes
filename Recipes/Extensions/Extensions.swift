//
//  Extensions.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import Foundation
import SwiftUI


extension Color {
    static let semiOrange = Color(#colorLiteral(red: 0.9411764706, green: 0.568627451, blue: 0.2117647059, alpha: 1))
    static let lightOrange = Color(#colorLiteral(red: 0.9725490196, green: 0.8235294118, blue: 0.5764705882, alpha: 1))
    static let semiBlack = Color(#colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1))
}

extension View {
    func size() -> CGSize {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        return window.screen.bounds.size
    }
}
