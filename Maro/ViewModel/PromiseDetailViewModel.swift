//
//  PromiseDetailViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/18.
//

import Combine
import SwiftUI

@MainActor
final class PromiseDetailViewModel: ObservableObject {
    let promise: PromiseEntity
    @Published var content = "" {
        didSet {
            if content.count > 25 && oldValue.count <= 25 {
                content = oldValue
            }
        }
    }
    @Published var memo = "" {
        didSet {
            if memo.count > 100 && oldValue.count <= 100 {
                memo = oldValue
            }
        }
    }
    @Published var selectedCategory = ""
    @Published var isShowingAlert = false
    @Published var textEditorHeight: CGFloat = 80 
    var inputCount: Int {
        content.count
    }

    var memoCount: Int {
        memo.count
    }

    init(promise: PromiseEntity) {
        self.promise = promise
        self.content = promise.content
        self.memo = promise.memo
        let category = Category(int: promise.category)
        self.selectedCategory = category?.toString ?? ""
    }
}

extension PromiseDetailViewModel {
    func didAllowDeletion(completion: @escaping (() -> Void)) {
        CoreDataManager.shared.deletePromise(promise: promise)
        completion()
    }

    func didTapCancel() {
        self.isShowingAlert = false
    }

    func didTapEditButton(completion: @escaping (() -> Void)) {
        guard let category = Category(string: selectedCategory) else { return }
        guard let todayIndex = UserDefaults.standard.string(forKey: Constant.todayIndex) else { return }
        var indexOfPromise = ""
        
        let promises = CoreDataManager.shared.getAllPromises()
        let optionalIndex = promises.firstIndex{$0 === promise}
        let index = optionalIndex ?? 0
        let result = index + 1

        if 10 <= result {
            indexOfPromise = String(result)
        } else {
            indexOfPromise = String("0\(result)")
        }

        if indexOfPromise == todayIndex {
            UserDefaults.standard.set(content, forKey: Constant.todayPromise)
        }

        CoreDataManager.shared.editPromise(
            promise: promise,
            content: content,
            memo: memo,
            category: category,
            isTodayPromise: promise.isTodayPromise
        )
        completion()
    }
    
    func calculateDateFormat() -> String {
        let formatter = DateFormatter(dateFormatType: .koreanYearMonthDay)
        let result = formatter.string(from: promise.createdAt ?? Date())
        return result
    }

    func isButtonAvailable() -> Bool {
        guard let selectedCategory = Category(string: selectedCategory) else { return false }
        if !(selectedCategory.rawValue == promise.category) || !(content == promise.content) {
            if content.isEmpty {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
