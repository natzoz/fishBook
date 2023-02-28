//
//  FishDataStore.swift
//  FishBook
//
//  Created by cs-488-01 on 2/21/23.
//

import Foundation
import SQLite

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
    private let occurance = Expression<String>("occurance")
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
                table.column(occurance)
                table.column(description)
            })
            insert()
            print("Table Created...")
        } catch {
            print(error)
        }
    }
    
     private func insert() {
        do {
            try db?.run(fishes.insert(commonName <- "Butterfly Fish 1", scientificName <- "Heniochus monocerus", group <- "Group", family <- "Family", habitat <- "Habitat", occurance <- "Occurance", description <- "Description 1"))
            try db?.run(fishes.insert(commonName <- "Butterfly Fish 2", scientificName <- "Heniochus flaviventris", group <- "Group", family <- "Family", habitat <- "Habitat", occurance <- "Occurance", description <- "Description 2"))
            try db?.run(fishes.insert(commonName <- "Butterfly Fish 3", scientificName <- "Heniochus acuminatus", group <- "Group", family <- "Family", habitat <- "Habitat", occurance <- "Occurance", description <- "Description 3"))
            print("insertion success")
        } catch {
            print("insertion failed: \(error)")
        }
    }
    
    //
    
    func getAllFish() -> [Fish] {
        var fishes: [Fish] = []
        guard let database = db else { return [] }
        
        do {
            for fish in try database.prepare(self.fishes) {
                fishes.append(Fish(id: fish[id], commonName: fish[commonName], scientificName: fish[scientificName], group: fish[group], family: fish[family], habitat: fish[habitat], occurrence: fish[occurance], description: fish[description]))
            }
        } catch {
            print(error)
        }
        return fishes
    }
    
}
