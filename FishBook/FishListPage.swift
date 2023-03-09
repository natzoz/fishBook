import SwiftUI

struct FishListPage: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    @State private var selectionFilter = "All Fish"
    @State private var selectionSort = "By Name: A to Z"
    
    let categoriesFilter = ["All Fish", "Group", "Family", "Occurrence", "Habitat"]
    let categoriesSort = ["By Name: A to Z", "By Name: Z to A", "By Scientific Name: A to Z", "By Scientific Name: Z to A"]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Filter", selection: $selectionFilter) {
                    ForEach(categoriesFilter, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Sort", selection: $selectionSort) {
                    ForEach(categoriesSort, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                ForEach(searchResults, id: \.self) {fish in
                    FishListCell(fish: fish)
                }
                
                ForEach(allHabitats, id: \.self) {habitat in
                    HabitatListCell(habitat: habitat)
                }
                
                ForEach(allFamilies, id: \.self) {family in
                    FamilyListCell(family: family)
                }
                
                ForEach(allOccurrences, id: \.self) {occurrence in
                    OccurrenceListCell(occurrence: occurrence)
                }

            }
            .navigationTitle("Fish Book")
        }
        .searchable(text: $searchText)
    }
    
    var allOccurrences: [String] {
        var resultList: [String] = []
        if selectionFilter == "Occurrence" {
            resultList = FishDataStore.share.getAllOccurrences()
        }
        return sortStringList(inputList: resultList)
    }
    
    var allFamilies: [String] {
        var resultList: [String] = []
        if selectionFilter == "Family" {
            resultList = FishDataStore.share.getAllFamilies()
        }
        return sortStringList(inputList: resultList)
    }
    
    var allHabitats: [String] {
        var resultList: [String] = []
        if selectionFilter == "Habitat" {
            resultList = FishDataStore.share.getAllHabitats()
        }
        return sortStringList(inputList: resultList)
    }
    
    var selectionResult: [Fish] {
        var resultList: [Fish] = []
        switch selectionFilter {
        case "Family":
            resultList = []
        case "Habitat":
            resultList = []
        case "Occurrence":
            resultList = []
        default:
            resultList = fishData.fishes
        }
        return sortFishList(inputList: resultList)
    }
    
    
    func sortFishList(inputList: [Fish]) -> [Fish] {
        var resultList: [Fish] = inputList
        switch selectionSort {
        case "By Name: A to Z":
            resultList = inputList.sorted{ $0.commonName < $1.commonName}
        case "By Name: Z to A":
            resultList = inputList.sorted{ $1.commonName < $0.commonName}
        case "By Scientific Name: A to Z":
            resultList = inputList.sorted{ $0.scientificName < $1.scientificName}
        case "By Scientific Name: Z to A":
            resultList = inputList.sorted{ $1.scientificName < $0.scientificName}
        default:
            resultList = inputList
        }
        return resultList
    }
    
    func sortStringList(inputList: [String]) -> [String] {
        var resultList: [String] = inputList
        switch selectionSort {
        case "By Name: A to Z":
            resultList = inputList.sorted()
        case "By Name: Z to A":
            resultList = (inputList.sorted()).reversed()
        case "By Scientific Name: A to Z":
            resultList = inputList.sorted()
        case "By Scientific Name: Z to A":
            resultList = (inputList.sorted()).reversed()
        default:
            resultList = inputList
        }
        return resultList
    }
    
    var searchResults: [Fish] {
        var resultList: [Fish] = []
        if searchText.isEmpty {
            return selectionResult
        } else {
            for fish in selectionResult {
                if (fish.commonName.localizedCaseInsensitiveContains(searchText) || fish.scientificName.localizedCaseInsensitiveContains(searchText)) {
                    resultList.append(fish)
                }
            }
            return resultList
        }
    }
}

struct OccurrenceListCell: View {
    var occurrence: String
   
    var body: some View {
        NavigationLink(destination: FishListPage(fishData: FishData(fishes: FishDataStore.share.getFishByOccurrence(givenOccurrence: occurrence)))){
            Text(occurrence)
        }
        .navigationTitle("Occurrences")
    }
}

struct FamilyListCell: View {
    var family: String
   
    var body: some View {
        NavigationLink(destination: FishListPage(fishData: FishData(fishes: FishDataStore.share.getFishByFamily(givenFamily: family)))){
            Text(family)
        }
        .navigationTitle("Families")
    }
}
    

struct HabitatListCell: View {
    var habitat: String

    var body: some View {
        NavigationLink(destination: FishListPage(fishData: FishData(fishes: FishDataStore.share.getFishByHabitat(givenHabitat: habitat)))){
            Text(habitat)
        }
        .navigationTitle("Habitats")
    }
}

struct FishListCell: View {
    var fish: Fish
    
    var body: some View {
        NavigationLink(destination: FishDetailPage(fish: fish)) {
            Image(fish.imageName)
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(fish.commonName)
                Text(fish.scientificName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct FishListPage_Previews: PreviewProvider {
    static var previews: some View {
        FishListPage(fishData: allFishData)
    }
}
