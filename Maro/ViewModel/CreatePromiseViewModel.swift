//
//  CreatePromiseViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import Combine

final class CreatePromiseViewModel: ObservableObject {
    @Published var content = "" {
        didSet {
            if content.count > 25 && oldValue.count <= 25 {
                content = oldValue
            }
        }
    }
    @Published var memo = ""
    @Published var selectedCategory = "선택"

    var inputCount: Int {
        content.count
    }

    func isButtonAvailable() -> Bool {
        if !content.isEmpty, selectedCategory != "선택" {
            return true
        } else {
            return false
        }
    }

    func didTapButton(completion: @escaping (() -> Void)) {
        if isButtonAvailable() {
            guard let category = Category(string: selectedCategory) else { return }
            CoreDataManager.shared.createPromise(
                content: content,
                category: category
            )
            completion()
        }
    }
}
