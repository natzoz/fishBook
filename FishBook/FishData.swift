import Foundation

class FishData : ObservableObject{
    @Published var fishes: [Fish]
    
    init(fishes: [Fish] = []) {
        self.fishes = fishes
    }
}

let allFishData = FishData(fishes: FishDataStore.share.getAllFish())
let testFishData = FishData(fishes: testData)
