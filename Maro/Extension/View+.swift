//
//  View+.swift
//  마로
//
//  Created by Noah's Ark on 2022/10/19.
//

import Foundation
import SwiftUI

extension View {
    // https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        return Path(path.cgPath)
    }
}
