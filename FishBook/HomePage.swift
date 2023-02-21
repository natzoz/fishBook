import SwiftUI

struct HomePage: View {

    @ObservedObject var fishData: FishData
    
    var body: some View {
        NavigationView {
            List(fishData.fishes) { fish in
                FishListCell(fish: fish)
            }
            .navigationTitle("Fish Book")
            
            Text("Select a fish to learn more about!")
                .font(.largeTitle)
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
        HomePage(fishData: allFishData)
    }
}
