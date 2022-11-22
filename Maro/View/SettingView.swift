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
        VStack(spacing: 22) {
            notificationSettingButton
            instagramLinkButton
            Spacer()
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
    var notificationSettingButton: some View {
        Toggle("알림 설정", isOn: $notificationStatus)
            .toggleStyle(SwitchToggleStyle(tint: .mainPurple))
    }
    
    var instagramLinkButton: some View {
        Link(destination: viewModel.instagramURL) {
            HStack {
                Text("개발자와 소통하기")
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
    }
    
    var dismissButton: some View {
        DismissButton { dismiss() }
    }
}
