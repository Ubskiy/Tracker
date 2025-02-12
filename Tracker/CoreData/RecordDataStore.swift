//
//  RecordDataStore.swift
//  Tracker
//
//  Created by Арсений Убский on 13.09.2023.
//

import CoreData

protocol RecordDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func interactWith(_ record: UUID, _ date: Date) throws
}
