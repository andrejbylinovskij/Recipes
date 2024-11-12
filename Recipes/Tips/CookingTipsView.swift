//
//  CookingTipsView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct CookingTipsView: View {
    
    @State private var bestTips: [Tip] = []
    @State private var otherTips: [Tip] = []
    
    @State var currentIndex: Int = 0
    @State var clubIndex: Int = 0
    @State var isShown = false
    @State var offset: CGFloat = 0
    
    @State var isShosn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("bg3")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        StrokeText(text: "Cooking Tips", width: 1, borderColor: .black, mainColor: .white)
                            .font(.system(size: 38, weight: .black))
                            .foregroundColor(.black)
                            .shadow(radius: 1)
      
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView {
                        
                        Text("Popular Tips")
                            .font(.system(size: 20, weight: .black))
                            .frame(width: size().width - 50, alignment: .leading)
                        
                        ZStack {
                            ForEach(0..<bestTips.count, id: \.self) { index in
                                Rectangle()
                                    .frame(width: size().width - 50, height: 250)
                                    .overlay {
                                        ZStack {
                                            Image(bestTips[index].imagePrompt)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: size().width - 50, height: 250)
                                                .overlay {
                                                    VStack {
                                                        Spacer()
                                                        
                                                        Text(bestTips[index].tip)
                                                            .font(.system(size: 22, weight: .light))
                                                            .foregroundStyle(.black)
                                                            .padding()
                                                            .background {
                                                                Rectangle()
                                                                    .frame(width: size().width - 50)
                                                                    .foregroundColor(.white).cornerRadius(24)
                                                            }
                                                   
                                                    }
                                                }
                                        }
                                    }
                                    .cornerRadius(24)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .scaleEffect( currentIndex == index ? 1 : 0.8)
                                    .offset(x: CGFloat(index - currentIndex) * size().width / 1.2 )
                                    .onTapGesture {
                                        isShosn.toggle()
                                    }
                                .fullScreenCover(isPresented: $isShosn) {
                                    TipDetailView(tip: bestTips[currentIndex])
                                }
                            }
                        }
                        .padding(.bottom, 80)
                        .gesture(
                            DragGesture()
                                .onEnded({ value in
                                    let threshold: CGFloat = 50
                                    if value.translation.width > threshold {
                                        withAnimation {
                                            currentIndex = max(0, currentIndex - 1)
                                            clubIndex = currentIndex
                                        }
                                    } else if value.translation.width < -threshold {
                                        withAnimation {
                                            currentIndex = min(bestTips.count - 1, currentIndex + 1)
                                            clubIndex = currentIndex
                                            
                                        }
                                    }
                                })
                        )
                        .frame(maxWidth: .infinity)
                        
                        Text("Other Tips")
                            .font(.system(size: 20, weight: .black))
                            .frame(width: size().width - 50, alignment: .leading)
                            .padding(.top, -70)
                        
                        VStack {
                            ForEach(otherTips, id: \.imagePrompt) { tip in
                                NavigationLink {
                                    TipDetailView(tip: tip).navigationBarBackButtonHidden()
                                } label: {
                                    ZStack {
                                        Image(tip.imagePrompt)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: size().width - 50, height: 250)
                                            .overlay {
                                                VStack {
                                                    Spacer()
                                                    
                                                    Text(tip.tip)
                                                        .font(.system(size: 22, weight: .light))
                                                        .foregroundStyle(.black)
                                                        .padding()
                                                        .background {
                                                            Rectangle()
                                                                .frame(width: size().width - 50)
                                                                .foregroundColor(.white).cornerRadius(24)
                                                        }
                                               
                                                }
                                            }
                                    }
                                    .frame(width: size().width - 50, height: 250)
                                    .cornerRadius(24)
                                }
                            }
                        }
                        .padding(.top, -40)
                        .padding(.bottom, 200)
                    }
                    
                    .scrollIndicators(.hidden)
                }
                
            }
        }
        .onAppear {
            bestTips = Array(parseMenu()?.prefix(6) ?? [])
            
            otherTips = Array(parseMenu()?.dropFirst(6) ?? [])
       
        }
    }
    
    func parseMenu() -> [Tip]? {
        guard let url = Bundle.main.url(forResource: "tips", withExtension: "json") else {
            print("not found")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let menuItems = try JSONDecoder().decode([Tip].self, from: data)
            return menuItems
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}

#Preview {
    CookingTipsView()
}
