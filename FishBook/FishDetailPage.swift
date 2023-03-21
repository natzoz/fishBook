import SwiftUI

struct FishDetailPage: View {
    var fish: Fish
    @State private var zoomed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ImageSlider(fish: fish)
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/2)
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
    
    var body: some View {
        TabView {
            ForEach(imageList, id: \.self) { item in
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
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("FishImages.bundle")

        do {
          let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)

          for item in contents
          {
              let imageName = NSString(string: String(item.lastPathComponent)).deletingPathExtension
              if (imageName.localizedCaseInsensitiveContains(fish.imageName)) {
                  resultList.append(imageName)
              }
          }
            if (resultList.isEmpty) {
                resultList.append("")
            }
            
            return resultList
        }
        catch {
          print(error)
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
