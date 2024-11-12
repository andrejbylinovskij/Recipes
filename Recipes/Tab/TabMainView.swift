//
//  TabMainView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case recipes, timer, tips, favorite
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .recipes:
            return "homeIcon"
        case .timer:
            return "timerIcon"
        case .tips:
            return "bookIcon"
        case .favorite:
            return "starIcon"
        }
    }
}

struct TabMainView: View {
    
    @State private var selectedTab = Tab.recipes
    @Namespace var namespace
    
    @State private var isTabBarShown = true
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
               
                TabView(selection: $selectedTab) {
                    
                   RecipesView()
                        .environmentObject(authViewModel)
                        .tag(Tab.recipes)
                    
                    TimerView {
                        withAnimation {
                            isTabBarShown.toggle()
                        }
                    }
                        .tag(Tab.timer)
                    
                    CookingTipsView()
                        .tag(Tab.tips)
                    
                FavoriteView()
                        .tag(Tab.favorite)
                }
                
                if isTabBarShown {
                    HStack(spacing: 0) {
                        TabButton(tab: .recipes, selectedTab: $selectedTab, namespace: namespace)
                        
                        Spacer(minLength: 0)
                        
                        TabButton(tab: .timer, selectedTab: $selectedTab, namespace: namespace)
                        
                        Spacer(minLength: 0)
                        
                        TabButton(tab: .tips, selectedTab: $selectedTab, namespace: namespace)
                        
                        Spacer(minLength: 0)
                        
                        TabButton(tab: .favorite, selectedTab: $selectedTab, namespace: namespace)
                    }
                    .padding(.horizontal, 40)
                    
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundColor(.white)
                            .frame(height: 70)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
           
            }
        }
        .tint(.white)
    }
}

#Preview {
    TabMainView()
}


private struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID
    let coloroid = Color(#colorLiteral(red: 0.9736717343, green: 0.8218023181, blue: 0.5760865808, alpha: 1))

    
    var body: some View {
        Button {
            withAnimation {
                selectedTab = tab
                
            }
        } label: {
            ZStack {
                Image(tab.icon)
                    .resizable()
                    .colorMultiply(isSelected ? coloroid : .white)
                    .scaleEffect(isSelected ? 1 : 0.8)
                    .offset(y: isSelected ? -10 : 0)
                    .animation(isSelected ? .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1) : .spring(), value: selectedTab)
                    .frame(width: 40, height: 40)
                 
            }
        }
        .buttonStyle(.plain)
    }
    
    private var isSelected: Bool {
        selectedTab == tab
    }
}
