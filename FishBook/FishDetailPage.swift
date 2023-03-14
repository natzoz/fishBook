import SwiftUI

struct FishDetailPage: View {
    var fish: Fish
    @State private var zoomed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(fish.imageName)
                .resizable()
                .cornerRadius(10)
                .padding(.horizontal, 10)
                .shadow(radius: 10)
                .aspectRatio(contentMode: zoomed ? .fill : .fit)
                .onTapGesture {
                    withAnimation {
                        zoomed.toggle()
                    }
                }
            VStack(alignment: .leading) {
                Text(fish.scientificName)
                    .font(.title)
                    .italic()
                    .padding(.bottom, 3)
                HStack {
                    Text("Family:").bold()
                    Text(fish.family)
                }
                HStack {
                    Text("Group:").bold()
                    Text(fish.group)
                }
                HStack {
                    Text("Occurrence:").bold()
                    Text(fish.occurrence)
                }
                HStack {
                    Text("Habitat:").bold()
                    Text(fish.habitat)
                }
            }
            .padding(.leading)
            Spacer()
        }
        .navigationTitle(fish.commonName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FishDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FishDetailPage(fish: testData[4])
        }
    }
}
