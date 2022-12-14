import Foundation

protocol StoreType {
    func fetchAll() throws -> [NoteElement]
    func store(_ todItem: NoteElement) throws
    func remove(_ todoItem: NoteElement) throws
}

struct UserDefaultStore: StoreType {
    func fetchAll() throws -> [NoteElement] {
        return []
        guard let data = UserDefaults.standard.data(forKey: "NoteElements") else {
            return []
        }
        let decoder = JSONDecoder()
        return try decoder.decode([NoteElement].self, from: data)
    }
    
    func store(_ noteItem: NoteElement) throws {
        var all = try fetchAll()
        all = [noteItem] + all
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(all)
        
        UserDefaults.standard.set(data, forKey: "NoteElements")
    }
    
    func remove(_ noteItem: NoteElement) throws {
        var all = try fetchAll()
        all.removeAll(where: { $0.title == noteItem.title })
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(all)
        
        UserDefaults.standard.set(data, forKey: "NoteElements")
    }
    
    
}
