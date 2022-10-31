//
//  MainViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {

    @Published var promises: Array<PromiseEntity> = []
    @Published var todayPromise: PromiseEntity? = nil
    @Published var isShowingLink = false
    @Published var isShowongAlert = false
    @Published var refreshTrigger = false
    var log = UserDefaults.standard.string(forKey: "log") {
        didSet {
            if oldValue != log {
                Task {
                    await resetIsTodayPromise()
                    await selectTodayPromise()
                }
            }
        }
    }
    
    func onAppear() {
        Task {
            await getAllPromises()
            await getTodayPromise()
            leaveLog()
        }
    }
}

extension MainViewModel {
    func getAllPromises() async {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.promises = CoreDataManager.shared.getAllPromises()
        }
    }

    func getTodayPromise() async {
        let result = CoreDataManager.shared.getTodayPromise()
        guard let result = result else {
            Task {
                await selectTodayPromise()
                await getTodayPromise()
            }
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.todayPromise = result
        }
    }

    func leaveLog() {
        let formatter = DateFormatter(dateFormatType: .yearMonthDay)
        self.log = formatter.string(from: Date())
    }

    func resetIsTodayPromise() async {
        for promise in promises {
            if promise.isTodayPromise == true {
                guard let category = Category(int: promise.category) else { return }
                CoreDataManager.shared.editPromise(
                    promise: promise,
                    content: promise.content,
                    memo: promise.memo,
                    category: category,
                    isTodayPromise: false
                )
            }
        }
    }

    func selectTodayPromise() async {
        guard let promise = promises.randomElement(),
              let category = Category(int: promise.category)
        else { return }

        if promise.identifier == todayPromise?.identifier {
            Task {
                await selectTodayPromise()
            }
            return
        }

        CoreDataManager.shared.editPromise(
            promise: promise,
            content: promise.content,
            memo: promise.memo,
            category: category,
            isTodayPromise: true
        )
    }

    func returnTodayPromise() -> PromiseEntity? {
        let filtered = promises.filter { promise in
            promise.isTodayPromise == true
        }
        return filtered.first
    }
}

extension MainViewModel {
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
