import SwiftUI

struct FamilyPage: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    @State private var currentSelection = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) {family in
                    NavigationLink(destination: FishListPage(fishData: fishData)) {
                        Text(family)
                    }
                }
            }
            .navigationTitle("Fish Families")
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [String] {
        var resultList: [String] = []
        if searchText.isEmpty {
            return fishData.families
        } else {
            for family in fishData.families {
                if (family.localizedCaseInsensitiveContains(searchText)) {
                    resultList.append(family)
                }
            }
            return resultList
        }
    }
}

struct FamilyPage_Previews: PreviewProvider {
    static var previews: some View {
        FamilyPage(fishData: allFishData)
    }
}
