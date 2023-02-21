import Foundation

struct Fish: Identifiable {
    var id: Int64
    
    var commonName: String
    var scientificName: String
    var group: String
    var family: String
    var habitat: String
    var occurrence: String
    var description: String
    
    var imageName: String { return scientificName}
}

