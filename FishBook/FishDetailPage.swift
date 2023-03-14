import SwiftUI

struct FishDetailPage: View {
    var fish: Fish
    @State private var zoomed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if (fish.imageCount <= 1) {
                Image(fish.imageName)
                    .resizable()
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .shadow(radius: 10)
                    .aspectRatio(contentMode: .fit)
            } else {
                ImageSlider(fish: fish)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
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

struct ImageSlider: View {
    var fish: Fish
//    @State private var images = imageList
    @State private var images = ["Chaetodon vagabundus", "Chaetodon xanthocephalus", "Chaetodon zanzibarensis"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { item in
                 Image(item)
                    .resizable()
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .shadow(radius: 10)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
 
    var imageList: [String] {
        var resultList: [String] = []
        if (fish.imageCount > 1) {
            for i in 1...fish.imageCount {
                resultList.append(fish.scientificName + String(i))
            }
        }
        return resultList
    }
    
}

struct FishDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FishDetailPage(fish: testData[4])
        }
    }
}
