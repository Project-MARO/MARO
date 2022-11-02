//
//  OnTapDismissKeyboardView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/31.
//

import SwiftUI

struct OnTapDismissKeyboardView: View {

    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        Rectangle()
            .opacity(0.00000000000000000001)
            .onTapGesture {
                isFocused.wrappedValue = false
            }
    }
}
