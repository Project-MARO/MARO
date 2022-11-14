//
//  MainViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published var promises: Array<PromiseEntity> = [] {
        didSet {
            let todayPromiseList = promises.filter({ promise in
                promise.isTodayPromise == true
            })
            if todayPromiseList.isEmpty {
                setTodaysPromise()
            } else {
                todayPromise = todayPromiseList.first
            }
        }
    }
    @Published var todayPromise: PromiseEntity? = nil
    @Published var isShowingLink = false
    @Published var isShowongAlert = false
    @Published var refreshTrigger = false
    var log = UserDefaults.standard.string(forKey: "log") {
        didSet {
            if log != oldValue {
                resetIsTodayPromise { [weak self] in
                    guard let self = self else { return }
                    self.setTodaysPromise()
                }
            }
            UserDefaults.standard.set(log, forKey: "log")
        }
    }

    func onAppear() {
        getAllPromises { [weak self] in
            guard let self = self else { return }
            self.leaveLog()
        }
    }

    func findIndex(promise: PromiseEntity?) -> String {
        guard promise != nil else { return "00"}
        let optionalIndex = promises.firstIndex{$0 === promise}
        guard let index = optionalIndex else { return "00" }
        let result = index + 1
        if 10 <= result {
            return String(result)
        } else {
            return String("0\(result)")
        }
    }

    func isCreatePromiseAvailable() -> Bool {
        if promises.count >= 10 {
            return false
        } else {
            return true
        }
    }
}

private extension MainViewModel {
    func getAllPromises(completion: @escaping () -> Void) {
        let result = CoreDataManager.shared.getAllPromises()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.promises = result
            completion()
        }
    }

    func leaveLog() {
        let formatter = DateFormatter(dateFormatType: .yearMonthDay)
        self.log = formatter.string(from: Date())
    }

    func resetIsTodayPromise(completion: @escaping () -> Void) {
        for promise in self.promises {
            if promise.isTodayPromise == true {
                guard let category = Category(int: promise.category)
                else { return }
                CoreDataManager.shared.editPromise(
                    promise: promise,
                    content: promise.content,
                    memo: promise.memo,
                    category: category,
                    isTodayPromise: false
                )
            }
            completion()
        }
    }

    func setTodaysPromise() {
        let todayPromise = self.promises.randomElement()
        guard let promise = todayPromise,
              let category = Category(int: promise.category)
        else { return }
        CoreDataManager.shared.editPromise(
            promise: promise,
            content: promise.content,
            memo: promise.memo,
            category: category,
            isTodayPromise: true
        )
        onAppear()
    }
}
