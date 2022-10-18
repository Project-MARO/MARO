//
//  View+.swift
//  마로
//
//  Created by Noah's Ark on 2022/10/19.
//

import Foundation
import SwiftUI

extension View {
    func bodyFontSetting() -> some View {
        modifier(bodyFontViewModifier())
    }
}

struct bodyFontViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(.mainTextColor)
            .multilineTextAlignment(.center)
    }
}
