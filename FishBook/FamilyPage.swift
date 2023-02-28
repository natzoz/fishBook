import SwiftUI

struct FamilyPage: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    
    var body: some View {
//        NavigationStack {
//
//        }
//        .searchable(text: $searchText)
        
        List {
            ForEach(searchResults, id: \.self) {family in fishData.families
                NavigationLink(destination: FishList(fishData: fishData)) {
                    Text(family)
                }
            }
        }
        .navigationTitle("Fish Families")
    }
    
    var searchResults: [Fish] {
        var resultList: [Fish] = []
        if searchText.isEmpty {
            return fishData.fishes
        } else {
            for fish in fishData.fishes {
                if (fish.family.localizedCaseInsensitiveContains(searchText)) {
                    resultList.append(fish)
                }
            }
            return resultList
        }
    }
}

//struct FishFamilyCell: View {
//    @ObservedObject var fishData: FishData
//
//    var body: some View {
//
//    }
//}

struct FamilyPage_Previews: PreviewProvider {
    static var previews: some View {
        FamilyPage(fishData: allFishData)
    }
}
