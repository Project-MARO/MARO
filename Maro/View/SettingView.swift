//
//  SettingView.swift
//  Maro
//
//  Created by Noah's Ark on 2022/11/04.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = SettingViewModel()
    @State var notificationStatus: Bool = UserDefaults.standard.bool(forKey: Constant.notificationStatus)
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.mainPurple)]
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(spacing: 0) {
            settingList
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: dismissButton)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .onAppear { viewModel.onAppear() }
        .onChange(of: notificationStatus) { newValue in
            viewModel.didTapToggle($notificationStatus)
        }
    }
}

private extension SettingView {
    var settingList: some View {
        VStack(spacing: 0) {
            notificationSettingButton
            Spacer()
        }
        .padding(.top, 30)
    }
    
    var notificationSettingButton: some View {
        Toggle("알림 설정", isOn: $notificationStatus)
            .toggleStyle(SwitchToggleStyle(tint: .mainPurple))
    }
    
    var dismissButton: some View {
        Button(action : {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
        }
    }
}
