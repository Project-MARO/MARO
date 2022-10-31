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
            // MARK: - 만약 로그 찍었을때 날짜가 바뀌었다면
            if oldValue != log {
                Task {
                    // MARK: - 오늘의 약속을 없애고
                    await resetIsTodayPromise()
                    // MARK: - 오늘의 약속을 새로 뽑는다
                    await selectTodayPromise()
                }
            }
        }
    }
    
    func onAppear() {
        Task {
            await getAllPromises()
            await getTodayPromise()
            // MARK: - 유저가 앱을 킨 날짜를 로그로 남겨서 저장한다
            leaveLog()
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

        // MARK: - 만약 이전 프로미스와 새로운 프로미스가 같다면 다시 고른다
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
}
