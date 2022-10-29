//
//  MainViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {

    @Published var promises: Array<PromiseEntity> = [] {
        didSet {
            randomePromise = promises.randomElement()
        }
    }
    @Published var isShowingLink = false
    @Published var randomePromise: PromiseEntity?
    @Published var isShowongAlert = false

    func onAppear() {
        getAllPromises()
    }
}

extension MainViewModel {
    func getAllPromises() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.promises = CoreDataManager.shared.getAllPromises()
        }
    }

    func findIndex(promise: PromiseEntity?) -> String {
        guard promise != nil else { return "00"}
        var index = promises.firstIndex{$0 === promise}!
        index = index + 1
        if 10 <= index {
            return String(index)
        } else {
            return String("0\(index)")
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
