//
//  CoreDataManager.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let container = NSPersistentContainer(name: CoreData.container)
    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        loadStores()
    }

    private func loadStores() {
        container.loadPersistentStores { desc, error in
              if let error = error {
                  print(error.localizedDescription)
              }
        }
    }
}

extension CoreDataManager {
    func save() {
        do {
            try context.save()
        } catch {
            print("FAILED TO SAVE CONTEXT")
        }
    }

    func getAllPromises() -> Array<PromiseEntity> {
        let fetchRequest: NSFetchRequest<PromiseEntity> = PromiseEntity.fetchRequest()
        let result = try? context.fetch(fetchRequest)
        return result ?? []
    }

    func getTodayPromise() -> PromiseEntity? {
        let fetchRequest: NSFetchRequest<PromiseEntity> = PromiseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isTodayPromise = %d", true)
        fetchRequest.fetchLimit = 1
        let result = try? context.fetch(fetchRequest).first
        return result
    }

    func createPromise(content: String, category: Category) {
        let promise = PromiseEntity(context: container.viewContext)
        promise.identifier = UUID().uuidString
        promise.content = content
        promise.createdAt = Date()
        promise.category = category.rawValue
        promise.isTodayPromise = false
        save()
    }

    func editPromise(promise: PromiseEntity, content: String, memo: String, category: Category, isTodayPromise: Bool) {
        promise.content = content
        promise.memo = memo
        promise.category = category.rawValue
        promise.isTodayPromise = isTodayPromise
        save()
    }

    func deletePromise(promise: PromiseEntity) {
        container.viewContext.delete(promise)
        save()
    }
}
