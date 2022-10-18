//
//  PromiseEntity.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import CoreData

@objc(PromiseEntity)
public class PromiseEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PromiseEntity> {
        return NSFetchRequest<PromiseEntity>(entityName: "PromiseEntity")
    }

    @NSManaged public var category: Int16
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var memo: String?

    var categoryEnum: Category {
        get {
            return Category(rawValue: self.category) ??  .study
        }
        set {
            self.category = newValue.rawValue
        }
    }
}

extension PromiseEntity : Identifiable {

}
