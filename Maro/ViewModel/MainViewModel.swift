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
    @Published var isShowingLink = false
    @Published var isShowongAlert = false
    var log = UserDefaults.standard.string(forKey: "log") {
        didSet {
            UserDefaults.standard.set(log, forKey: "log")
        }
    }
    
    func onAppear() {
        Task {
            await getAllPromises()
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
}

extension MainViewModel {
    
//    func getPromiseById() -> PromiseEntity? {
//        guard let promiseID = self.promiseID else { return nil }
//        guard let promise = CoreDataManager.shared.getPromiseBy(id: promiseID) else { return nil }
//        return promise
//    }

//    func isStoreRandomPromiseNeeded() async {
//        if promises.isEmpty { return }
//
//        guard let log = self.log,
//              let promiseID = self.promiseID
//        else {
//            storeRandomPromise()
//            return
//        }
//
//        if hasOverOneDay(log: log) {
//            storeRandomPromise()
//        }
//    }

//    func storeRandomPromise() {
//        guard let promise = getRandomPromise() else { return }
//
//        if (promise.identifier == self.promiseID) {
//            if promises.count == 1 {
//                return
//            } else {
//                storeRandomPromise()
//            }
//        }
//
//        let formatter = DateFormatter(dateFormatType: .yearMonthDay)
//        let log = formatter.string(from: Date())
//        self.promiseID = promise.identifier
//        self.log = log
//    }

    func hasOverOneDay(log: String) -> Bool {
        let formatter = DateFormatter(dateFormatType: .yearMonthDay)
        guard let logDate = formatter.date(from: log) else { return false }
        let current = Date()
        let components = Calendar.current.dateComponents([.day], from: logDate, to: current)
        if components.day! > 1 {
            return true
        } else {
            return false
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
