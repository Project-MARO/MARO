//
//  CoreDataManager.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let container = NSPersistentContainer(name: "DataModel")
    private let cloudContainer = NSPersistentCloudKitContainer(name: "DataModel")
    private let databaseName = "DataModel.sqlite"
    private var context: NSManagedObjectContext {
        container.viewContext
    }

    var oldStoreURL: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(databaseName)
    }

    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.kim.Maro")!
        return container.appendingPathComponent(databaseName)
    }

    init() {
        print("core data init")

        if !FileManager.default.fileExists(atPath: oldStoreURL.path) {
            print("old store doesn't exist. Using new shared URL")
            container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }

        print("Container URL = \(container.persistentStoreDescriptions.first!.url!)")

        container.loadPersistentStores { desc, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }

        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func migrateStore(for container: NSPersistentContainer) {
        print("Went into MigrateStore")
        let coordinator = container.persistentStoreCoordinator

        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else { return }
        print("old store no longer exists")

        do {
            let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            print("Migration Succeed")
        } catch {
            fatalError("Unable to migrate to shared store")
        }

        do {
            try FileManager.default.removeItem(at: oldStoreURL)
            print("Old Store Deleted")
        } catch {
            print("Unable to delete oldStore")
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

    func getPromiseBy(id identifier: String) -> PromiseEntity? {
        let fetchRequest: NSFetchRequest<PromiseEntity> = PromiseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        let result = try? context.fetch(fetchRequest).first
        return result
    }

    func createPromise(content: String, memo: String, category: Category) {
        let promise = PromiseEntity(context: container.viewContext)
        promise.identifier = UUID().uuidString
        promise.content = content
        promise.memo = memo
        promise.createdAt = Date()
        promise.category = category.rawValue
        save()
    }

    func editPromise(promise: PromiseEntity, content: String, memo: String, category: Category) {
        promise.content = content
        promise.memo = memo
        promise.category = category.rawValue
        save()
    }

    func deletePromise(promise: PromiseEntity) {
        container.viewContext.delete(promise)
        save()
    }
}
