//
//  CategoriesDataStore.swift
//  Tracker
//
//  Created by Арсений Убский on 13.09.2023.
//

import CoreData

protocol CategoriesDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ record: CategoryModel) throws
    func delete(_ record: NSManagedObject) throws
}
