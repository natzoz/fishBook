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
        let imageList = imageList()
        print(imageList)
        let allFish = getAllFish()
        print(allFish)
        
        for fish in allFish {
            if !imageList.contains(fish.imageName){
                downloadFishPhoto(fishName: fish.imageName)
            }
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
            checkConnection()
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
    
    private func checkConnection(){
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/quinntonelli/fish_book_editing@latest/fishdata.csv") else { return }
        let downloadTask = URLSession.shared.downloadTask(with: url){
            urlOrNil, responseOrNil, errorOrNil in
            guard let fileURL = urlOrNil else { return }
            do {
                let savedURL = Bundle.main.url(forResource: "fishdata", withExtension: "csv")!
                let path = URL(fileURLWithPath: "/Users/cs-488-01/Desktop/sofdev-s23-fish/FishBook/fishdata.csv")
//                print("SAVED URL:")
//                print(savedURL)
//                print("FILE URL:")
//                print(fileURL)
                try FileManager.default.replaceItemAt(path, withItemAt: fileURL)
                try FileManager.default.replaceItemAt(savedURL, withItemAt: fileURL)
                } catch {
                    print ("file error: \(error)")
                }
                self.refresh()
        }
        downloadTask.resume()
        print("success")
    }
    
    private func downloadFishPhoto(fishName: String) {
        if fishName == "Siganus sutor"{
            guard let url = URL(string: "https://github.com/quinntonelli/fish_book_editing/blob/main/fish_photos/Siganus%20sutor.jpeg") else { return }
            let downloadTask = URLSession.shared.downloadTask(with: url){
                urlOrNil, responseOrNil, errorOrNil in
                guard let fileUrl = urlOrNil else { return }
                do {
                    let fishAssets = Bundle.main.url(forResource: "Fish", withExtension: "xcassets")
                    print(fishAssets)
                    let fishBundle = Bundle.main.url(forResource: "FishImages", withExtension: "bundle")
                    print(fishBundle)
                    try FileManager.default.moveItem(at: fileUrl, to: fishAssets!)
                    try FileManager.default.moveItem(at: fileUrl, to: fishBundle!)
                }
            }
            downloadTask.resume()
            print("success")
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
    
    func getFishByFamily(givenFamily: String) -> [Fish] {
        let fishes = getAllFish()
        var sortedFish: [Fish] = []
        for fish in fishes {
            if fish.family == givenFamily {
                sortedFish.append(fish)
            }
        }
        return sortedFish
    }
    
    func getAllOccurrences() -> [String] {
        var occurrences: [String] = []
        guard let database = db else { return [] }
        
        do {
            for fish in try database.prepare(self.fishes) {
                if (!occurrences.contains(fish[occurrence])) {
                    occurrences.append(fish[occurrence])
                }
            }
        } catch {
            print(error)
        }
        return occurrences
    }
    
    func getFishByOccurrence(givenOccurrence: String) -> [Fish] {
        let fishes = getAllFish()
        var sortedFish: [Fish] = []
        for fish in fishes {
            if fish.occurrence == givenOccurrence {
                sortedFish.append(fish)
            }
        }
        return sortedFish
    }
    
    func getAllHabitats() -> [String] {
        var habitats: [String] = []
        guard let database = db else { return [] }
        
        do {
            for fish in try database.prepare(self.fishes) {
                if (!habitats.contains(fish[habitat])) {
                    habitats.append(fish[habitat])
                }
            }
        } catch {
            print(error)
        }
        return habitats
    }
    
    func getFishByHabitat(givenHabitat: String) -> [Fish] {
        let fishes = getAllFish()
        var sortedFish: [Fish] = []
        for fish in fishes {
            if fish.habitat == givenHabitat {
                sortedFish.append(fish)
            }
        }
        return sortedFish
    }
    
    func getAllGroups() -> [String] {
        var groups: [String] = []
        guard let database = db else { return [] }
        
        do {
            for fish in try database.prepare(self.fishes) {
                if (!groups.contains(fish[group])) {
                    groups.append(fish[group])
                }
            }
        } catch {
            print(error)
        }
        return groups
    }
    
    func getFishByGroup(givenGroup: String) -> [Fish] {
        let fishes = getAllFish()
        var sortedFish: [Fish] = []
        for fish in fishes {
            if fish.group == givenGroup {
                sortedFish.append(fish)
            }
        }
        return sortedFish
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
    
    func imageList() -> [String] {
        var resultList: [String] = []
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("FishImages.bundle")
        let allFish = getAllFish()

        do {
          let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)

          for item in contents
          {
              for fish in allFish {
                  let imageName = NSString(string: String(item.lastPathComponent)).deletingPathExtension
                  if (imageName.localizedCaseInsensitiveContains(fish.imageName)) {
                      resultList.append(imageName)
                  }
              }

          }
            if (resultList.isEmpty) {
                resultList.append("")
            }
            
            return resultList
        }
        catch {
          print(error)
        }
        
        return resultList
    }
    
}
