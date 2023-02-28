import SwiftUI

struct FishList: View {
    @ObservedObject var fishData: FishData
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults, id: \.self) {fish in
                    FishListCell(fish: fish)
                }
            }
            .navigationTitle("Fish")
            
            Text("Select a fish to learn more about!")
                .font(.largeTitle)
        }
        .searchable(text: $searchText)
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

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        FishList(fishData: allFishData)
    }
}
