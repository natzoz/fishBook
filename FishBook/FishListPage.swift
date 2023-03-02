import SwiftUI

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
                }
                .pickerStyle(.menu)
                
                updateList(data: fishData, selection: selection)
                
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
    
    func updateList(data: FishData, selection: String) -> FishData {
        if (selection == "All Fish") {
            let data = fishAtoZ
        }
        
        return data
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
