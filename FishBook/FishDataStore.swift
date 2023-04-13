import Foundation
import UIKit
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
        checkAndDownloadPhotos()
    }
    
    func checkAndDownloadPhotos() {
        let bundleList = bundleList()
        let uploads = uploadList()
        
        for img in uploads {
            if (!bundleList.contains(img)){
                downloadFishPhoto(fishName: img)
            }
        }
        print("Photo Download Function Complete.")
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
        let semaphore = DispatchSemaphore(value: 0)
        let downloadTask = URLSession.shared.downloadTask(with: url){
            urlOrNil, responseOrNil, errorOrNil in
            defer {
                semaphore.signal()
            }
            guard let fileURL = urlOrNil else { return }
            do {
                let savedURL = Bundle.main.url(forResource: "fishdata", withExtension: "csv")!
                let path = URL(fileURLWithPath: "/Users/cs-488-01/Desktop/sofdev-s23-fish/FishBook/fishdata.csv")
                try FileManager.default.replaceItemAt(path, withItemAt: fileURL)
                try FileManager.default.replaceItemAt(savedURL, withItemAt: fileURL)
                } catch {
                    print ("file error: \(error)")
                }
                self.refresh()
        }
        downloadTask.resume()
        semaphore.wait()
    }
    
    private func downloadFishPhoto(fishName: String) {
        let newFishName = fishName.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "https://cdn.jsdelivr.net/gh/quinntonelli/fish_book_editing@latest/fish_photos/" + newFishName + ".jpeg")!
        let semaphore = DispatchSemaphore(value: 0)
        let downloadTask = URLSession.shared.downloadTask(with: url){
            urlOrNil, responseOrNil, errorOrNil in
            defer {
                semaphore.signal()
            }
            guard let fileUrl = urlOrNil else { return }
            do {
                guard let bundleURL = Bundle.main.url(forResource: "FishImages", withExtension: "bundle") else {
                    print("Could not find FishPhotos.bundle")
                    return
                }
                let desktopBundleURL = URL(fileURLWithPath: "/Users/cs-488-01/Desktop/sofdev-s23-fish/FishBook/FishImages.bundle")
                let newFileURL = desktopBundleURL.appendingPathComponent("\(fishName).jpeg")
                try FileManager.default.copyItem(at: fileUrl, to: newFileURL)
                
                print("\n BundleURL")
                print(bundleURL)
                print("\n")
                let newBundleFileURL = bundleURL.appendingPathComponent("\(fishName).jpeg")
                print("\n newBundleFileURL")
                print(newBundleFileURL)
                print("\n")
                try FileManager.default.copyItem(at: fileUrl, to: newBundleFileURL)
                
                let desktopBundleURL = URL(fileURLWithPath: "/Users/cs-488-01/Desktop/sofdev-s23-fish/FishBook/FishImages.bundle")
                let newFileURL = desktopBundleURL.appendingPathComponent("\(fishName).jpeg")
                try FileManager.default.copyItem(at: fileUrl, to: newFileURL)
                let desktopAssetURL = URL(fileURLWithPath: "/Users/cs-488-01/Desktop/sofdev-s23-fish/FishBook/Fish.xcassets")
                let imageFolderURL = desktopAssetURL.appendingPathComponent("\(fishName).imageset")
                if !FileManager.default.fileExists(atPath: imageFolderURL.path) {
                    do {
                        try FileManager.default.createDirectory(at: imageFolderURL, withIntermediateDirectories: false, attributes: nil)
                    } catch {
                        print(error.localizedDescription)
                        return
                    }
                }

                let newAssetFileURL = imageFolderURL.appendingPathComponent("\(fishName).jpeg")
                try FileManager.default.copyItem(at: fileUrl, to: newAssetFileURL)
                
                self.createJsonFileForPhoto(assetURL: imageFolderURL, imageName: fishName)
                
            } catch {
                print("file error: \(error)")
            }
        }
        downloadTask.resume()
        semaphore.wait()

    }
    
    private func createJsonFileForPhoto(assetURL: URL, imageName: String){
        let contents: [String: Any] = [
            "images": [
                [
                    "filename": imageName + ".jpeg",
                    "idiom": "universal",
                    "scale": "1x"
                ],
                [
                    "idiom": "universal",
                    "scale": "2x"
                ],
                [
                    "idiom": "universal",
                    "scale": "3x"
                ]
            ],
            "info": [
                "author": "xcode",
                "version": 1
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
            let jsonURL = assetURL.appendingPathComponent("Contents.json")
            try jsonData.write(to: jsonURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
            return
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
    
    func bundleList() -> [String] {
        var resultList: [String] = []
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("FishImages.bundle")

        do {
          let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)

          for item in contents
          {
              let imageName = NSString(string: String(item.lastPathComponent)).deletingPathExtension
              if (!resultList.contains(imageName)) {
                  resultList.append(imageName)
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
    
    func uploadList() -> [String] {
        guard let url = URL(string: "https://cdn.jsdelivr.net/gh/quinntonelli/fish_book_editing@main/fish_photos/") else { return [] }
        
        var fileNames: [String] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                semaphore.signal()
            }
            guard let data = data, error == nil else {
                print("Error while fetching file names: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let html = String(data: data, encoding: .utf8){
                
                let regex = try! NSRegularExpression(pattern: #"<a[^>]*href\s*=\s*["'][^"']*\/(?<filename>[^\/"']+)\.(?:jpg|jpeg|png|gif)["'][^>]*>(?<text>.*?)<\/a>"#, options: [])
                let matches = regex.matches(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count))
                
                fileNames = matches.compactMap { match in
                    let range = match.range(at: 1)
                    if let swiftRange = Range(range, in: html) {
                        return String(html[swiftRange])
                    } else {
                        return nil
                    }
                }
            }
        }
        task.resume()
        
        semaphore.wait()
        
        return fileNames
    }

}
