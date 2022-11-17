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
    
    // Request whether a user will allow notification
    func requestAuthorizaiton() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error { print("Error: \(error)") }
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
        let _ = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: calendarTrigger
        )
        
        UNUserNotificationCenter.current().add(request)
        UserDefaults.standard.set(true, forKey: "notificationStatus")
    }
    
    // Check user's notification status
    func verifyNotificationStatus() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings { permission in
            switch permission.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                UserDefaults.standard.set(true, forKey: Constant.notificationStatus)
            case .denied, .notDetermined:
                UserDefaults.standard.set(false, forKey: Constant.notificationStatus)
            @unknown default:
                UserDefaults.standard.set(false, forKey: Constant.notificationStatus)
            }
        }
    }
    
    // Cancel notificaiton
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
