//
//  Persistence.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//

import CoreData

/// A singleton for working with Core Data. Saving, deleting, creating test data, preparing preview data.
class PersistenceController: ObservableObject {
    let container: NSPersistentContainer

    /// Simple data keeping in memory for preview canvas.
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        for index in 0..<3 {
            let newTimer = WPTimer(context: viewContext)
            let newDates = WPHistoryDates(context: viewContext)
            newDates.startDate = Date().addingTimeInterval(Double(index * -3000))
            newDates.endDate = Date().addingTimeInterval(Double(index * -500))
            newTimer.historyDates = NSSet(object: newDates)
            newTimer.name = "Timer example \(index)"
            newTimer.startDate = Date().addingTimeInterval(Double(index * -5000))
            newTimer.isActive = index % 2 == 0
        }
        return controller
    }()

    
    /// Initializes a Persistence, either in memory or on permanent storage. Causes fatal error if loadPersistentStores returns error.
    /// - Parameter inMemory: Whether to store data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Willpower")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }

    /// Save data if view context has changes. Causes fatal error if save is not successful.
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    /// Delete object from the storage.
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    
    /// Returns the number of objects from the storage
    /// - Parameter request: entity type
    /// - Returns: number of objects or zero
    func count(for request: NSFetchRequest<NSFetchRequestResult>) -> Int {
        let count =  try? container.viewContext.count(for: request)
        return count ?? 0
    }
    
    /// Delete ALL objects from the storage. Use only for testing purposes.
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = WPHistoryDates.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = WPTimer.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    func createSamples() {
        let context = container.viewContext
        
        let timer = WPTimer(context: context)
        timer.name = "Without cofffee"
        let startDateComp = DateComponents(day: -14, hour: -15, minute: -14)
        timer.startDate = Calendar.current.date(byAdding: startDateComp, to: Date())
        timer.isActive = true
        
        let dates1 = WPHistoryDates(context: context)
        let startDateComp1 = DateComponents(month: -2, day: -6, hour: -19)
        let endDateComp1 = DateComponents(month: -2, day: -1, hour: -9)
        dates1.startDate = Calendar.current.date(byAdding: startDateComp1, to: Date())
        dates1.endDate = Calendar.current.date(byAdding: endDateComp1, to: Date())
        
        let dates2 = WPHistoryDates(context: context)
        let startDateComp2 = DateComponents(month: -2, day: -1, hour: -9)
        let endDateComp2 = DateComponents(day: -26, hour: -1, minute: -41)
        dates2.startDate = Calendar.current.date(byAdding: startDateComp2, to: Date())
        dates2.endDate = Calendar.current.date(byAdding: endDateComp2, to: Date())
        
        let dates3 = WPHistoryDates(context: context)
        let startDateComp3 = DateComponents(day: -26, hour: -1, minute: -41)
        let endDateComp3 = DateComponents(day: -14, hour: -15, minute: -14)
        dates3.startDate = Calendar.current.date(byAdding: startDateComp3, to: Date())
        dates3.endDate = Calendar.current.date(byAdding: endDateComp3, to: Date())
        
        timer.historyDates = NSSet(objects: dates1, dates2, dates3)
        
        save()
    }
}
