import SwiftUI

@main
struct FishBookApp: App {
    @StateObject private var fishData = FishData()
    
    var body: some Scene {
        WindowGroup {
            Frontview()
        }
    }
}
