//
//  PromiseDetailViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/18.
//

import Foundation
import Combine

final class PromiseDetailViewModel: ObservableObject {

    let promise: PromiseEntity

    @Published var content = "" {
        didSet {
            if content.count > 25 && oldValue.count <= 25 {
                content = oldValue
            }
        }
    }
    @Published var memo = ""
    @Published var selectedCategory = "" {
        didSet {
            didFinishEditing()
        }
    }
    @Published var isShowingAlert = false

    var inputCount: Int {
        content.count
    }

    let pickers = ["학업", "취업", "인생", "자기계발", "인간관계"]

    init(promise: PromiseEntity) {
        self.promise = promise
        self.content = promise.content ?? ""
        self.memo = promise.memo ?? ""
        let category = Category(int: promise.category)
        self.selectedCategory = category?.toString ?? ""
    }

    func didFinishEditing() {
        CoreDataManager.shared.editPromise(
            promise: promise,
            content: content,
            memo: memo,
            category: Category(string: selectedCategory)!
        )
    }

    func didAllowDeletion(completion: @escaping (() -> Void)) {
        CoreDataManager.shared.deletePromise(promise: promise)
        completion()
    }
}
