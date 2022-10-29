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
    @Published var randomPromise: PromiseEntity?
    @Published var isShowongAlert = false
//    var randomPromiseID: String {
//        get {
//            UserDefaults.standard.string(forKey: "randomPromiseID") ?? ""
//        }
//    }

    func onAppear() {
        Task {
            await getAllPromises()
//            await getPromiseByID()
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

//    func getPromiseByID() async {
//        let result = CoreDataManager.shared.getPromiseBy(id: randomPromiseID)
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.randomPromise = result
//        }
//    }

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
