import Foundation

class FishData : ObservableObject{
    @Published var fishes: [Fish]
    @Published var families: [String]
    
    init(fishes: [Fish] = [], families: [String] = []) {
        self.fishes = fishes
        self.families = families
    }
}

let allFishData = FishData(fishes: FishDataStore.share.getAllFish(), families: FishDataStore.share.getAllFamilies())
let testFishData = FishData(fishes: testData)
