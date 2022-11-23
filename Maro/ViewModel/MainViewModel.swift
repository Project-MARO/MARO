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
    @Published var promises: Array<PromiseEntity> = []
    @Published var todayIndex: String? = ""
    @Published var todayPromise: String? = ""
    @Published var isShowingLink = false
    @Published var isShowongAlert = false
    @Published var refreshTrigger = false
    var log = UserDefaults.standard.string(forKey: Constant.log) {
        didSet {
            if log != oldValue {
                self.setTodaysPromise()
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.todayIndex = UserDefaults.standard.string(forKey: Constant.todayIndex)
                self.todayPromise = UserDefaults.standard.string(forKey: Constant.todayPromise)
            }
            
            UserDefaults.standard.set(log, forKey: Constant.log)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.leaveLog),
            name: .NSCalendarDayChanged,
            object: nil
        )
    }
    
    func onAppear() {
        getAllPromises { [weak self] in
            guard let self = self else { return }
            let log = UserDefaults.standard.string(forKey: Constant.log)
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
        if promises.count >= 10 { return false }
        else { return true }
    }
}

private extension MainViewModel {
    @objc func leaveLog() {
        let formatter = DateFormatter(dateFormatType: .yearMonthDay)
        self.log = formatter.string(from: Date())
    }
    
    func getAllPromises(completion: @escaping () -> Void) {
        let result = CoreDataManager.shared.getAllPromises()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.promises = result
            completion()
        }
    }
    
    func setTodaysPromise() {
        let randomPromise = self.promises.randomElement()
        guard let promise = randomPromise else { return }
        guard let todayPromise = self.todayPromise else { return }
        let index = findIndex(promise: promise)
        
        if todayPromise == promise.content {
            setTodaysPromise()
        } else {
            UserDefaults.standard.set(index, forKey: Constant.todayIndex)
            UserDefaults.standard.set(promise.content, forKey: Constant.todayPromise)
            DispatchQueue.main.async {
                self.todayPromise = promise.content
                self.todayIndex = index
            }
            onAppear()
        }
    }
}
