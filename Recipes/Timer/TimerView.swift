//
//  TimerView.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

struct TimerView: View {
    @StateObject private var vm = TimerViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var completion: () -> ()
    
    var body: some View {
            ZStack {
                Image("bg1")
                    .resizable()
                    .ignoresSafeArea()
                
                GeometryReader { proxy in
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.03))
                                .padding(-40)
                            
                            Circle()
                                .trim(from: 0, to: vm.progress)
                                .stroke(.white.opacity(0.03), lineWidth: 80)
                            
                            Circle()
                                .stroke(Color.semiOrange.opacity(0.7), lineWidth: 5)
                                .blur(radius: 15)
                                .padding(-2)
                            
                            Circle()
                                .fill(Color.white)
                            
                            Circle()
                                .trim(from: 0, to: vm.progress)
                                .stroke(Color.semiOrange.opacity(0.7), lineWidth: 10)
                            
                            GeometryReader { proxy in
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        Circle()
                                            .fill(Color.white)
                                            .padding(5)
                                    }
                                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                                    .rotationEffect(.init(degrees: vm.progress * 360))
                                    .offset(x: proxy.size.height / 2)
                            }
                            
                            Text("\(vm.time)")
                                .font(.system(size: 45, weight: .black))
                                .rotationEffect(.init(degrees: 90))
                                .foregroundColor(.black)
                                .animation(.none, value: vm.progress)
                        }
                        .padding(60)
                        .frame(height: proxy.size.width)
                        .rotationEffect(.init(degrees: -90))
                        .animation(.easeInOut, value: vm.progress)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        
                        Button {
                            if vm.isActive {
                                vm.reset()
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            } else {
                                completion()
                                vm.isSheetShown.toggle()
                            }
                        } label: {
                            Image(systemName: !vm.isActive ? "timer" : "stop.fill")
                                .foregroundColor(.white)
                                .font(.largeTitle.bold())
                                .frame(width: 80, height: 80)
                                .background {
                                    Circle()
                                        .fill(Color.orange)
                                        .shadow(color: .white, radius: 8, x: 0, y: 0)
                                }
                        }
                        .padding(.bottom, 150)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .overlay {
                ZStack {
                    Color.white
                        .opacity(vm.isSheetShown ? 0.25 : 0)
                        .onTapGesture {
                            vm.hour = 0
                            vm.minute = 0
                            vm.isSheetShown = false
                            completion()
                        }
                    SetTimer()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: vm.isSheetShown ? 0 : 400)
                }
                .animation(.easeInOut, value: vm.isSheetShown)
            }
        
        .onAppear {
            vm.authsorizeNotification()
        }
        .sheet(isPresented: $vm.isHintShown) {

        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
        }
        .alert("Time is over", isPresented: $vm.isAlertShown) {
            Button("OK", role: .cancel) {
                
            }
        }
    }
    
    @ViewBuilder
    func SetTimer() -> some View {
        VStack(spacing: 15) {
            Text("Add New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15) {
 
                Menu {
                    ContextMenuOptions(maxValue: 59, hint: "min") { value in
                        vm.minute = value
                    }
                } label: {
                    Text("Set")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background {
                            Capsule()
                                .fill(.orange)
                        }
                }
                
                ForEach(0..<3) { i in
                    Button {
                        withAnimation {
                            vm.minute = 15 - i
                        }
                        
                    } label: {
                        Text("\(15 - i) min")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background {
                                Capsule()
                                    .fill(.orange)
                                    .frame(width: 80, height: 80)
                            }
                    }
                }
                
            
                
            }
            .padding(.top, 20)
            
            Button {
                vm.start()
                vm.isSheetShown = false
                completion()
            } label: {
                Text("Start \(vm.minute) min Timer")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 100)
                    .background {
                        Capsule()
                            .fill(Color.semiOrange)
                    }
            }
            .disabled(vm.hour == 0 && vm.minute == 0)
            .opacity(vm.hour == 0 && vm.minute == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.lightOrange)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int, hint: String, onClick: @escaping (Int) -> ()) -> some View {
        ForEach(1...maxValue, id: \.self) { value in
            Button {
                onClick(value)
            } label: {
                Text("\(value) \(hint)")
            }
        }
    }
}

#Preview {
    TimerView(){}
}
