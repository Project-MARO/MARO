//
//  BottomButtonView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/31.
//

import SwiftUI

struct BottomButtonView: View {

    let type: ButtonType
    let action: () -> Void
    let isButtonAvailable: Bool

    init(
        type: ButtonType,
        isButtonAvailable: Bool,
        action: @escaping () -> Void
    ) {

        self.type = type
        self.isButtonAvailable = isButtonAvailable
        self.action = action
      }

    var body: some View {
        VStack {
            Spacer()
            Button {
                action()
            } label: {
                Text(self.type.rawValue)
                    .font(.headline)
                    .foregroundColor(
                        isButtonAvailable ?
                        Color.white :
                        Color.inputBackground)
                    .padding(.vertical, 18)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(isButtonAvailable ?
                        Color.mainPurple :
                        Color.inputCount
                    )
                    .cornerRadius(10)
            }
            .padding(.bottom, 16)
        }
    }
}

enum ButtonType: String {
    case create = "약속 만들기"
    case edit = "수정 하기"
}
