//
//  NotificationManager.swift
//  Maro
//
//  Created by Noah's Ark on 2022/11/04.
//

import SwiftUI
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    @Published var currentStatus: Bool = false
    
    // Request whether a user will allow notification
    func requestAuthorizaiton() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("User did touch notification setting pop-up")
            }
        }
    }
    
    // Set automatic notifications on daily basis
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "오늘의 약속을 확인해보세요!"
        content.sound = .default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 7
        dateComponents.minute = 0
        
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: timeTrigger
        )
        
        UNUserNotificationCenter.current().add(request)
        print("😍 5 Notification Schedule Setting Done!")
    }
    
    // Check user's notification status
    func verifyNotificationStatus() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                print("authorized")
                self.currentStatus = true
                print("🔥 2 NotificationManager: \(self.currentStatus)")
            case .denied, .notDetermined:
                print("denied")
                self.currentStatus = false
                print("🔥 2 NotificationManager: \(self.currentStatus)")
            @unknown default:
                print("Hello")
                self.currentStatus = false
                print("🔥 2 NotificationManager: \(self.currentStatus)")
            }
        }
    }
    
    // Cancel notificaiton
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("🎁 6 Notification Cancelled")
    }
}
