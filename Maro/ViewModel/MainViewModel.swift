//
//  MainViewModel.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {

    @Published var allPromises: Array<PromiseEntity> = [] {
        didSet {
            randomePromise = allPromises.randomElement()
        }
    }
    @Published var isShowingLink = false
    @Published var randomePromise: PromiseEntity?

    func onAppear() {
        getAllPromises()
    }
}

extension MainViewModel {
    func getAllPromises() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.allPromises = CoreDataManager.shared.getAllPromises()
        }
    }

    func findIndex(promise: PromiseEntity?) -> String {
        guard promise != nil else { return "00"}
        var index = allPromises.firstIndex{$0 === promise}!
        index = index + 1
        if 10 <= index {
            return String(index)
        } else {
            return String("0\(index)")
        }
    }
}
