import SwiftUI

public var viewIndex = 0

struct FrontView: View {
    @State private var randfish = false

    var body: some View{
        return Group{
            if viewIndex == 0 {
                VStack{
                    FishListPage(fishData: allFishData)
                    HStack{
                        Button("random fish") {
                            view = 2
                        }
                        Button("family") {
                            view = 1
                        }
                        Button("all fish") {
                            view = 0
                        }
                    }
                }
            }else if viewIndex == 1{
                VStack{
                    FamilyPage(fishData: allFishData)
                    HStack{
                        Button("random fish") {
                            view = 2
                        }
                        Button("family") {
                            view = 1
                        }
                        Button("all fish") {
                            view = 0
                        }
                    }
                }
            }else if viewIndex == 2{
                VStack{
                    FishDetailPage(fish: allFishData.fishes.randomElement()!)
                    HStack{
                        Button("random fish") {
                            view = 2
                        }
                        Button("family") {
                            view = 1
                        }
                        Button("all fish") {
                            view = 0
                        }
                    }
                }
            }
        }
//        return Group{
//            if randfish {
//                VStack{
//                    FishDetailPage(fish: allFishData.fishes.randomElement()!)
//                    Button("Go Back") {
//                        randfish.toggle()
//                    }                }
//            }else{
//                VStack{
//                    FishListPage(fishData: allFishData)
//                    Button("Random fish") {
//                        randfish.toggle()
//                    }
//                }
//            }
//        }
    }
}

struct FishListPage: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    @State private var selection = "All Fish"

    let categories = ["All Fish", "Group", "Family", "Occurrence", "Habitat"]
    
    var body: some View {
        NavigationView {
            List {
                Picker("Filter", selection: $selection) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                    if 
                }
                .onChange(of: selection, perform: { (value) in
                    print(selection)
                    if (selection == "All Fish") {
                        viewIndex = 0
                    } else if (selection == "Family") {
                        viewIndex = 1
                    } else if (selection == "Habitat") {
                        viewIndex = 2
                    }
                })
                .pickerStyle(.menu)
                
                ForEach(searchResults, id: \.self) {fish in
                    FishListCell(fish: fish)
                }
            }
            .navigationTitle("Fish Book")
            
            Text("Select a fish to learn more about!")
                .font(.largeTitle)
        }
        .searchable(text: $searchText)
    }
    
    var selectionResult: [Fish] {
        var resultList: [Fish] = []
        switch selection {
        case "All Fish":
            resultList = FishDataStore.share.getAllFish()
        case "Family":
            resultList = FishDataStore.share.getFishByFamily(givenFamily: "Charcharhinidae")
        case "Habitat":
            resultList = FishDataStore.share.getFishByHabitat(givenHabitat: "Reef edge/drop offs")
        default:
            resultList = FishDataStore.share.getAllFish()
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
//        FishListPage(fishData: allFishData)
        FrontView()
    }
}
