//
//  TimerViewModel.swift
//  Recipes
//
//  Created by D K on 04.11.2024.
//

import SwiftUI

class TimerViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var progress: Double = 1.0
    
    @Published var hour = 0
    @Published var minute = 0
        
    @Published var isActive = false
    @Published var time: String = "00:00"
    @Published var isAlertShown = false
    @Published var isSheetShown = false
    @Published var isHintShown = false
    
    private var initialTime: TimeInterval = 0
    private var remainingTime: TimeInterval = 0
    private var endDate = Date()
    
    enum TimeUnit {
        case seconds
        case minutes
        case hours
    }
    
    func convertToSeconds(value: Int, unit: TimeUnit) -> TimeInterval {
        switch unit {
        case .seconds:
            return TimeInterval(value)
        case .minutes:
            return TimeInterval(value * 60)
        case .hours:
            return TimeInterval(value * 60 * 60)
        }
    }
    
    func start() {
        isAlertShown = false
        let inputValue = (hour * 60 * 60) + (minute * 60)
    
        self.initialTime = convertToSeconds(value: inputValue, unit: .seconds)
        self.remainingTime = self.initialTime
        self.endDate = Date().addingTimeInterval(self.remainingTime)
        self.isActive = true
        
        addNotification()
    }
    
    func reset() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        progress = 1
        hour = 0
        minute = 0
        isActive = false
        time = "00:00"
    }
    
    func updateCountdown() {
        guard isActive else { return }

        let now = Date()
        let diff = endDate.timeIntervalSince(now)
                
        
        if diff <= 0 {
            self.isActive = false
            self.time = "00:00"
            progress = 0
            isAlertShown = true
            return
        }

        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        let seconds = Int(diff) % 60

        if hours > 0 {
            self.time = String(format:"%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            self.time = String(format:"%02d:%02d", minutes, seconds)
        }
        
        self.progress = diff / initialTime
    }

    
    override init() {
        super.init()
    }
    
    func authsorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { _, _  in
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    func addNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "Time's up!"
        content.subtitle = "Check your dish"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(initialTime), repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
}
