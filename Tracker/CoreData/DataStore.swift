//
//  DataStore.swift
//  Tracker
//
//  Created by Арсений Убский on 13.09.2023.
//

import Foundation
import CoreData

// MARK: - DataStore
final class DataStore {
    
    private let modelName = "Trackers"
    private let storeURL = NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("data-store.sqlite")
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    init() throws {
        guard let modelUrl = Bundle(for: DataStore.self).url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch let error as NSError {
            print("Произошла ошибка при инициализации dataStore: \(error.localizedDescription)")
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}

// MARK: - TrackersDataStore
extension DataStore: TrackersDataStore {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
    
    func add(_ record: TrackerModel, categoryId: UUID, categoryTitle: String) throws {
        try performSync { context in
            Result {
                // Проверяем, существует ли уже категория с указанным categoryId
                let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "CategoriesCoreData")
                fetchRequest.predicate = NSPredicate(format: "id == %@", categoryId as NSUUID)
                let existingCategories = try context.fetch(fetchRequest)
                
                var finalCategory: TrackerCategoryCoreData
                if let firstCategory = existingCategories.first {
                    finalCategory = firstCategory
                } else {
                    let newCategory = TrackerCategoryCoreData(context: context)
                    newCategory.id = UUID()
                    newCategory.title = categoryTitle
                    newCategory.creationDate = Date()
                    finalCategory = newCategory
                }
                
                let trackersCoreData = TrackerCoreData(context: context)
                trackersCoreData.title = record.name
                trackersCoreData.categoryId = finalCategory.id
                trackersCoreData.creationDate = Date()
                trackersCoreData.emoji = record.emoji
                
                trackersCoreData.schedule = configSchedule(schedule: record.schedule)
                                            
                trackersCoreData.color = Int16(record.color)
                trackersCoreData.id = UUID()
                
                // Устанавливаем отношение между трекером и категорией
                trackersCoreData.trackerToCategory = finalCategory
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Ошибка при сохранении контекста: \(error)")
                }
            }
        }
    }
    
    func configSchedule(schedule: Set<WeekDay>) -> String {
        var scheduleString:String = ""
        schedule.forEach {
            day in scheduleString += "\(day)"
        }
        return scheduleString
    }
    
    func calculateWeekDayNumber(for date: Date) -> Int {
        let calendar = Calendar.current
        let weekDayNumber = calendar.component(.weekday, from: date) // first day of week is Sunday
        let daysInWeek = 7
        return (weekDayNumber - calendar.firstWeekday + daysInWeek) % daysInWeek + 1
    }
    
    func numberOfExecutions(for trackerId: UUID) -> Int {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "ExecutionsCoreData")
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@", trackerId as NSUUID)
        let count = try? context.count(for: fetchRequest)
        return count ?? 0
    }
    
    func hasExecutionForDate(for trackerId: UUID, date: Date) -> Bool {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "ExecutionsCoreData")
        fetchRequest.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", trackerId as NSUUID, date as NSDate)
        let count = try? context.count(for: fetchRequest)
        return count ?? 0 > 0
    }
    
    
    
    
    func delete(_ record: NSManagedObject) throws {
        try performSync { context in
            Result {
                context.delete(record)
                try context.save()
            }
        }
    }
}

extension DataStore: CategoriesDataStore {
    func add(_ record: CategoryModel) throws {
        try performSync { context in
            Result {
                let categoriesCoreData = TrackerCategoryCoreData(context: context)
                categoriesCoreData.title = record.title
                categoriesCoreData.creationDate = Date()
                try context.save()
            }
        }
    }
}

extension DataStore: RecordDataStore {
    func interactWith(_ record: UUID, _ date: Date) throws {
        // Попробуем получить существующие выполнения для данного трекера и даты
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate, #keyPath(TrackerRecordCoreData.trackerId), record as NSUUID)
        fetchRequest.resultType = .managedObjectIDResultType
        
        do {
            let existingExecutions = try context.fetch(fetchRequest) as! [NSManagedObjectID]
            if existingExecutions.isEmpty {
                attachExecution(trackerId: record, date: date)
            } else {
                if let objectId = existingExecutions.first {
                    detachExecution(byObjectId: objectId)
                }
            }
        } catch {
            print("FATAL ERROR: \(error)")
            throw error
        }
    }
    
    private func attachExecution(trackerId: UUID, date: Date) {
        let newExecution = TrackerRecordCoreData(context: context)
        newExecution.date = date
        newExecution.trackerId = trackerId
        
        do {
            try context.save()
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrackerRecordCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate, #keyPath(TrackerRecordCoreData.trackerId), trackerId as NSUUID)
        } catch let error as NSError {
            print("Ошибка при сохранении выполнения: \(error.localizedDescription)")
        }
    }
    
    private func detachExecution(byObjectId objectId: NSManagedObjectID) {
        if let objectToDelete = context.object(with: objectId) as? TrackerRecordCoreData {
            context.delete(objectToDelete)
            do {
                try context.save()
            } catch let error as NSError {
                print("Ошибка при удалении выполнения: \(error.localizedDescription)")
            }
        }
    }
    
}

