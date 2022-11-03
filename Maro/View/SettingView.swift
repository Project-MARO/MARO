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
        .onChange(of: viewModel.isNotificationAllowed) { newValue in
            print("👀 3 SettingView: \(newValue)")
            viewModel.didTapToggle(newValue)
        }
    }
}

private extension SettingView {
    var settingList: some View {
        VStack(spacing: 0) {
            Toggle("알림 설정", isOn: $viewModel.isNotificationAllowed)
                .toggleStyle(SwitchToggleStyle(tint: .mainPurple))
            Spacer()
        }
        .padding(.top, 30)
    }
    
    var dismissButton: some View {
        Button(action : {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
        }
    }
}
