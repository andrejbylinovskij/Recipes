//
//  StartView.swift
//  Recipes
//
//  Created by D K on 11.11.2024.
//

import SwiftUI

struct StartView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabMainView()
                    .environmentObject(viewModel)
            } else {
                LogInView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    StartView()
}
