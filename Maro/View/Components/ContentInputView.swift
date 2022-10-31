//
//  ContentInputView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/31.
//

import SwiftUI

struct ContentInputView: View {

    var isFocused: FocusState<Bool>.Binding
    @Binding var content: String
    var inputCount: Int

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("약속 내용")
                    .font(.headline)

                Spacer()

                Text("\(inputCount)/25")
                    .foregroundColor(Color.inputCount)
            }

            TextField("약속 내용을 입력해주세요", text: $content)
                .customTextFieldSetting()
                .focused(isFocused)
        }
        .padding(.top, 30)
    }
}

