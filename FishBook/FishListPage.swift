import SwiftUI

struct FishListPage: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    @State private var selectionFilter = "All Fish"
    @State private var selectionSort = "By Name: A to Z"
    
    let categoriesFilter = ["All Fish", "Group", "Family", "Occurrence", "Habitat"]
    let categoriesSort = ["By Name: A to Z", "By Name: Z to A", "By Scientific Name: A to Z", "By Scientific Name: Z to A"]
    
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
                
                ForEach(searchResults, id: \.self) {fish in
                    FishListCell(fish: fish)
                }
                
                ForEach(allHabitats, id: \.self) {habitat in
                    HabitatListCell(habitat: habitat)
                }

//                updateList(data: fishData, selection: selection)
                
//                ForEach(selectionResult, id: \.self) {
//                    fish in FishListCell(fish: fish)
//                }

            }
            .navigationTitle("All Fish")
            
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
        case "Family":
            resultList = FishDataStore.share.getFishByFamily(givenFamily: "Charcharhinidae")
        case "Habitat":
            resultList = []
        default:
            resultList = fishData.fishes
        }
        return sortFishList(inputList: resultList)
    }
    
    var allHabitats: [String] {
        var resultList: [String] = []
        if selectionFilter == "Habitat" {
            resultList = FishDataStore.share.getAllHabitats()
        }
        return sortStringList(inputList: resultList)
    }
    
    func sortFishList(inputList: [Fish]) -> [Fish] {
        var resultList: [Fish] = inputList
        print("sorting")
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
        print("sorting")
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
        print(resultList)
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

struct HabitatListCell: View {
    var habitat: String
    let gesture = TapGesture().onEnded {
            print("Gesture Hit")
        }
    
    var body: some View {
        NavigationLink(destination: FishListPage(fishData: FishData(fishes: FishDataStore.share.getFishByHabitat(givenHabitat: habitat)))){
            Text(habitat)
        }
        .navigationTitle("Habitats")
//        Text(habitat)
//            .simultaneousGesture(gesture)
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
