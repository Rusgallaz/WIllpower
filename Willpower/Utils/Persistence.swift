//
//  Persistence.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 02.06.2021.
//

import CoreData

class PersistenceController: ObservableObject {
    let container: NSPersistentContainer

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

    func createSimpleData() throws {

    }

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

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = WPHistoryDates.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = WPTimer.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
}
