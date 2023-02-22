import Foundation

struct Fish: Hashable {
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

let testData = [
    Fish(id: 1, commonName: "Masked bannerfish", scientificName: "Heniochus monocerus", group: "Butterflyfishes", family: "Chaetodontidae", habitat: "Reef associated, near drop offs/deep reef", occurrence: "occasional", description: "Description"),
    Fish(id: 2, commonName: "Longnose butterflyfish", scientificName: "Forcipiger flaviventris", group: "Butterflyfishes", family: "Chaetodontidae", habitat: "Reef associated, near live corals", occurrence: "occasional", description: "Description"),
    Fish(id: 3, commonName: "Pennant coralfish", scientificName: "Heniochus acuminatus", group: "Butterflyfishes", family: "Chaetodontidae", habitat: "Reef associated, near drop offs", occurrence: "occasional", description: "Description"),
    Fish(id: 4, commonName: "Zanzibar butterflyfish", scientificName: "Chaetodon zanzibarensis", group: "Butterflyfishes", family: "Chaetodontidae", habitat: "Reef associated, near live corals", occurrence: "common", description: "Description"),
    Fish(id: 5, commonName: "Yellowhead butterflyfish", scientificName: "Chaetodon xanthocephalus", group: "Butterflyfishes", family: "Chaetodontidae", habitat: "Reef associated, near live corals", occurrence: "occasional", description: "Description"),
    Fish(id: 6, commonName: "Vagabond butterflyfish", scientificName: "Chaetodon vagabundus", group: "Butterflyfishes", family: "Chaetodontidae", habitat: "Reef associated, near live corals", occurrence: "common", description: "Description")
]
