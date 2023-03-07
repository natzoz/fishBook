import SwiftUI

struct FishListPage: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    @State private var selectionFilter = "All Fish"
    @State private var selectionSort = "By Name: A to Z"
    
    let categoriesFilter = ["All Fish", "Group", "Family", "Occurrence", "Habitat"]
    let categoriesSort = ["By Name: A to Z", "By Name: Z to A", "By Occurrence: Common to Rare", "By Occurrence: Rare to Common"]
    
    var body: some View {
        NavigationView {
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
                
//                .onChange(of: selection, perform: { (value) in
//                    if (selection == "All Fish") {
//
//                    }
//                })
                .pickerStyle(.menu)
                
//                updateList(data: fishData, selection: selection)
                
                ForEach(selectionResult, id: \.self) {
                    fish in FishListCell(fish: fish)
                }
                
//                ForEach(searchResults, id: \.self) {fish in
//                    FishListCell(fish: fish)
//                }
            }
            .navigationTitle("Fish Book")
            
            Text("Select a fish to learn more about!")
                .font(.largeTitle)
        }
        .searchable(text: $searchText)
    }
    
//    func updateList(data: FishData, selection: String) -> FishData {
//        if (selection == "All Fish") {
//            let data = fishAtoZ
//        }
//
//        return data
//    }
    
    var selectionResult: [Fish] {
        var resultList: [Fish] = []
        switch selectionFilter {
        case "All Fish":
            resultList = FishDataStore.share.getAllFish()
        case "Family":
            resultList = FishDataStore.share.getFishByFamily(givenFamily: "Charcharhinidae")
        case "Habitat":
            resultList = FishDataStore.share.getFishByHabitat(givenHabitat: "Reef edge/drop offs")
        default:
            resultList = FishDataStore.share.getAllFish()
        }
        return sortList(inputList: resultList)
    }
    
    func sortList(inputList: [Fish]) -> [Fish] {
        var resultList: [Fish] = inputList
        print("sorting")
        switch selectionSort {
        case "By Name: A to Z":
            resultList = inputList.sorted{ $0.commonName < $1.commonName}
        case "By Name: Z to A":
            resultList = inputList.sorted{ $1.commonName < $0.commonName}
        case "By Occurrence: Common to Rare":
            resultList = inputList.sorted{ $0.occurrence < $1.occurrence}
        case "By Occurrence: Rare to Common":
            resultList = inputList.sorted{ $1.occurrence < $0.occurrence}
        default:
            resultList = inputList
        }
        return resultList
    }
    
    var searchResults: [Fish] {
        var resultList: [Fish] = []
        if searchText.isEmpty {
            return fishData.fishes
        } else {
            for fish in fishData.fishes {
                if (fish.commonName.localizedCaseInsensitiveContains(searchText) || fish.scientificName.localizedCaseInsensitiveContains(searchText)) {
                    resultList.append(fish)
                }
            }
            return resultList
        }
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
