import Foundation
import CoreData

struct CoreDataStore: StoreType {
    
    private let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteApp")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Device full or data model was modified without a migration")
            }
        }
        return container
    }()
    
    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchAll() throws -> [NoteElement] {
        let context = container.viewContext
        
        let fetchRequest = NoteElementEntity.fetchRequest()
        
        let NoteElementEntities = try context.fetch(fetchRequest)
        
        return NoteElementEntities.compactMap { NoteElementEntity in
            guard
                let title = NoteElementEntity.title,
                let note = NoteElementEntity.note,
                let date = NoteElementEntity.date
            else {
                return nil
            }
            return NoteElement(title: title, note: note,date: date)
        }.sorted {
            $0.date > $1.date
        }
    }
    
    func store(_ NoteItem: NoteElement) throws {
        let context = container.viewContext
        let entity = NoteElementEntity(context: context)
        entity.title = NoteItem.title
        entity.note = NoteItem.note
        entity.date = NoteItem.date
        
        try context.save()
    }
    
    func remove(_ NoteItem: NoteElement) throws {
        let context = container.viewContext
        let fetchRequest = NoteElementEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", NoteItem.title)
        
        let entities = try context.fetch(fetchRequest)
        
        for entity in entities {
            context.delete(entity)
        }
        try context.save()
    }
}
