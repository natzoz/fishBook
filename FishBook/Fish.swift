import Foundation

struct Fish: Identifiable {
    var id = UUID()
    
    var commonName: String
    var scientificName: String
    var group: String
    var family: String
    var habitat: String
    var occurence: String
    var description: String
    
    var imageName: String { return scientificName}
}

let testData = [
    Fish(commonName: "Butterfly Fish1", scientificName: "Heniochus monocerus", group: "test", family: "test", habitat: "Coral dominated", occurence: "common", description: "Description"),
    Fish(commonName: "Butterfly Fish2", scientificName: "Forcipiger flaviventris", group: "test", family: "test", habitat: "Coral dominated", occurence: "common", description: "Description"),
    Fish(commonName: "Butterfly Fish3", scientificName: "Heniochus acuminatus", group: "test", family: "test", habitat: "Coral dominated", occurence: "common", description: "Description"),
    Fish(commonName: "Butterfly Fish4", scientificName: "Chaetodon zanzibarensis", group: "test", family: "test", habitat: "Coral dominated", occurence: "common", description: "Description"),
    Fish(commonName: "Butterfly Fish5", scientificName: "Chaetodon xanthocephalus", group: "test", family: "test", habitat: "Coral dominated", occurence: "common", description: "Description"),
    Fish(commonName: "Butterfly Fish6", scientificName: "Chaetodon vagabundus", group: "test", family: "test", habitat: "Coral dominated", occurence: "common", description: "Description")
]
