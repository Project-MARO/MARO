//
//  DismissButton.swift
//  Maro
//
//  Created by Noah's Ark on 2022/11/22.
//

import SwiftUI

struct DismissButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action : {
            action()
        }) {
            Image(systemName: "arrow.left")
        }
    }
}
