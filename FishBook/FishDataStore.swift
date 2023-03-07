import Foundation
import SQLite
import TabularData

class FishDataStore {
    
    static let DIR_FISH_DB = "FishDB"
    static let STORE_NAME = "fish.sqlite3"
    
    private let fishes = Table("fish")
    
    private let id = Expression<Int64>("id")
    private let commonName = Expression<String>("commonName")
    private let scientificName = Expression<String>("scientificName")
    private let group = Expression<String>("group")
    private let family = Expression<String>("family")
    private let habitat = Expression<String>("habitat")
    private let occurrence = Expression<String>("occurrence")
    private let description = Expression<String>("description")
    
    static let share = FishDataStore()
    
    private var db: Connection? = nil
    
    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_FISH_DB)
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath)")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }
    
    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(fishes.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(commonName)
                table.column(scientificName)
                table.column(group)
                table.column(family)
                table.column(habitat)
                table.column(occurrence)
                table.column(description)
            })
            insert()
            print("Table Created...")
        } catch {
            refresh()
            print(error)
        }
    }
    
    private func insert() {
        let url = Bundle.main.url(forResource: "fishdata", withExtension: "csv")!
        let datatable = try? DataFrame(contentsOfCSVFile: url)
        let rowcount = datatable?.rows.count
        do {
            for i in 0...(rowcount!-1){
                try db?.run(fishes.insert(
                    commonName <- (datatable![row: i][2, String.self])!,
                    scientificName <- (datatable![row: i][3, String.self])!,
                    group <- (datatable![row: i][0, String.self])!,
                    family <- (datatable![row: i][1, String.self])!,
                    habitat <- (datatable![row: i][5, String.self])!,
                    occurrence <- (datatable![row: i][4, String.self])!,
                    description <- "Description"))
            }
            print("Inserted " , rowcount! , " fish")
        } catch {
            print("insertion failed: \(error)")
        }
    }
    
    private func refresh() {
        let table = Table("fish")
        let drop = table.drop(ifExists: true)
        do{
            try db!.run(drop)
            print("refreshed")
        } catch {
            print(error)
        }
        createTable()
    }
    
    func getAllFish() -> [Fish] {
        var fishes: [Fish] = []
        guard let database = db else { return [] }
        
        do {
            for fish in try database.prepare(self.fishes) {
                fishes.append(Fish(id: fish[id], commonName: fish[commonName], scientificName: fish[scientificName], group: fish[group], family: fish[family], habitat: fish[habitat], occurrence: fish[occurrence], description: fish[description]))
            }
        } catch {
            print(error)
        }
        return fishes
    }
    
    func getAllFamilies() -> [String] {
        var families: [String] = []
        guard let database = db else { return [] }
        
        do {
            for fish in try database.prepare(self.fishes) {
                if (!families.contains(fish[family])) {
                    families.append(fish[family])
                }
            }
        } catch {
            print(error)
        }
        return families
    }
    
    func getFishAToZ() -> [Fish] {
            var fishes = getAllFish()
            fishes = fishes.sorted{ $0.commonName < $1.commonName}
            return fishes
        }
        
    func getFishZtoA() -> [Fish] {
        var fishes = getAllFish()
        fishes = fishes.sorted{ $0.commonName > $1.commonName}
        return fishes
    }
    
}
