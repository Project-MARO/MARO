//
//  SettingViewModel.swift
//  Maro
//
//  Created by Noah's Ark on 2022/11/04.
//

import Foundation
import SwiftUI

final class SettingViewModel: ObservableObject {

    func onAppear() {
        NotificationManager.shared.verifyNotificationStatus()
    }
    
    func didTapToggle(_ status: Binding<Bool>) {
        switch status.wrappedValue {
        case true:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url) { permissionStatus in
                    if permissionStatus {
                        NotificationManager.shared.requestAuthorizaiton()
                        NotificationManager.shared.scheduleNotification()
                    } else {
                        UserDefaults.standard.set(false, forKey: Constant.notificationStatus)
                    }
                }
            }
        case false:
            NotificationManager.shared.cancelNotification()
            UserDefaults.standard.set(false, forKey: Constant.notificationStatus)
        }
    }
}
