//
//  TrackersDataStore.swift
//  Tracker
//
//  Created by Арсений Убский on 13.09.2023.
//

import CoreData

protocol TrackersDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(_ record: TrackerModel, categoryId: UUID, categoryTitle: String) throws
    func delete(_ record: NSManagedObject) throws
    func numberOfExecutions(for trackerId: UUID) -> Int
    func hasExecutionForDate(for trackerId: UUID, date: Date) -> Bool
}

