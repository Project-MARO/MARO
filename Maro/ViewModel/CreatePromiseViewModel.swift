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
    var count: Int

    init(count: Int) {
        self.count = count
    }

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
            if count == 0 {
                CoreDataManager.shared.createPromise(
                    content: content,
                    category: category,
                    isTodayPromise: true
                )
            } else {
                CoreDataManager.shared.createPromise(
                    content: content,
                    category: category,
                    isTodayPromise: false
                )
            }
            completion()
        }
    }
}
