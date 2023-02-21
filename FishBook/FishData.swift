import Foundation

class FishData : ObservableObject{
    @Published var fishes: [Fish]
    
    init(fishes: [Fish] = []) {
        self.fishes = fishes
    }
}

let testFishData = FishData(fishes: testData)
