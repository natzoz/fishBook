import SwiftUI

struct FamilyPage: View {
    @ObservedObject var fishData: FishData
    
    var body: some View {
        NavigationStack {
            List {
                let families: [String] = fishData.families
                ForEach(families, id: \.self) {family in
                    NavigationLink(destination: FishList(fishData: fishData)) {
                        Text(family)
                    }
                }
            }
            .navigationTitle("Fish Families")
        }
        
    }
}

struct FamilyPage_Previews: PreviewProvider {
    static var previews: some View {
        FamilyPage(fishData: allFishData)
    }
}
