import SwiftUI

struct FishDetailPage: View {
    var fish: Fish
    @State private var zoomed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(fish.imageName)
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            VStack(alignment: .leading) {
                Text(fish.commonName).font(.headline)
                Text(fish.scientificName)
                Text("Occurrence: " + fish.occurrence)
                Text("Habitat: " + fish.habitat)
                Text("Description: " + fish.description)
            }
            .padding(.leading)
            Spacer()
        }
        .navigationTitle(fish.commonName)
    }
}

struct FishDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FishDetailPage(fish: testData[1])
        }
    }
}
