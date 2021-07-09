//
//  TimersStorage.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 06.07.2021.
//

import Foundation
import CoreData

class TimersStorage: NSObject, ObservableObject {
    @Published var timers: [WPTimer] = []
    
    private let controller: NSFetchedResultsController<WPTimer>
    
    init(managedObjectContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<WPTimer>(entityName: "WPTimer")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \WPTimer.isActive, ascending: false),
            NSSortDescriptor(keyPath: \WPTimer.startDate, ascending: true)
        ]
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        controller.delegate = self
        
        do {
            try controller.performFetch()
            timers = controller.fetchedObjects ?? []
        } catch {
            fatalError("Can't load timers.")
        }
    }
    
}

extension TimersStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let fetchedTimers = controller.fetchedObjects as? [WPTimer] else { return }
        
        timers = fetchedTimers
    }
}
