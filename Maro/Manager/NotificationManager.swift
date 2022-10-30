//
//  NotificationManager.swift
//  마로
//
//  Created by Noah's Ark on 2022/10/19.
//

//import Foundation
//import UserNotifications
//
//final class NotificationManager {
//    static let shared = NotificationManager()
//
//    func requestAuthorization() {
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
//            if let error = error {
//                print("ERROR: \(error)")
//            } else {
//                print("SUCCESS")
//            }
//        }
//    }
//
//    func scheduleNotification() {
//        let randomPromise = CoreDataManager.shared.getAllPromises().randomElement()
//        var randomPromiseID = UserDefaults.standard.string(forKey: "randomPromiseID") {
//            didSet {
//                UserDefaults.standard.set(randomPromiseID, forKey: "randomPromiseID")
//            }
//        }
//        randomPromiseID = randomPromise?.identifier
//
//        let content = UNMutableNotificationContent()
//        content.title = randomPromise?.content ?? "Hello"
//        content.sound = .default
//
//        var dateComponents = DateComponents()
//        dateComponents.hour = 17
//        dateComponents.minute = 25
//
//        let trigger = UNCalendarNotificationTrigger(
//            dateMatching: dateComponents,
//            repeats: true
//        )
//
//        let request = UNNotificationRequest(
//            identifier: UUID().uuidString,
//            content: content,
//            trigger: trigger
//        )
//
//        UNUserNotificationCenter.current().add(request)
//    }
//}
