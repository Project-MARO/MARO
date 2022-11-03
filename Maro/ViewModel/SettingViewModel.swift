//
//  SettingViewModel.swift
//  Maro
//
//  Created by Noah's Ark on 2022/11/04.
//

import Foundation

final class SettingViewModel: ObservableObject {
    @Published var isNotificationAllowed = false
    
    func onAppear() {
        NotificationManager.shared.verifyNotificationStatus()
        self.isNotificationAllowed = NotificationManager.shared.currentStatus
        print("✅ 1 SettingViewModel: \(self.isNotificationAllowed)")
    }
    
    func didTapToggle(_ status: Bool) {
        switch status {
        case true:
            print("😇 4 SettingViewModel: \(self.isNotificationAllowed)")
            NotificationManager.shared.requestAuthorizaiton()
            NotificationManager.shared.scheduleNotification()
        case false:
            print("😇 4 SettingViewModel: \(self.isNotificationAllowed)")
            NotificationManager.shared.cancelNotification()
        }
    }
}

