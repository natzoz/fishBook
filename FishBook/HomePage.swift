import SwiftUI

struct Frontview: View {
    @State private var randfish = false
    @State private var fishlist = false
    @State private var ishidden = false
    @State private var ishiddenp2 = false
    var body: some View{
        return Group{
            if randfish {
                VStack{
                    FishDetailPage(fish: allFishData.fishes.randomElement()!)
                    Button("Go Back") {
                        randfish.toggle()
                    }.buttonStyle( .bordered)
                }
            }else if fishlist{
                VStack{
                    FishListPage(fishData: allFishData)
                    Button("Home Page") {
                        fishlist.toggle()
                    }.buttonStyle( .bordered)
                }
                .ignoresSafeArea(.keyboard)
            }else{
                Spacer()
                VStack{
                    Text("FishBook").font(.title)
                    Button(action: {
                        if let url = URL(string: "https://github.com/quinntonelli/fish_book_editing/blob/main/AboutFishBook.pdf") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("About the Project")
                    }
                    HomePage_ImageSlider()
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3)
                        .onTapGesture{ishidden.toggle()}
                        //.onAppear(perform: FishDataStore.share.checkAndDownloadPhotos)
                    if ishidden{
                        VStack{
                            Text("Welcome to the world of Fish!")
                            Text("gulb gulb gulb").font(.caption)
                        }.onTapGesture {
                            ishiddenp2.toggle()
                        }
                    }
                    
                    Spacer()
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                            Text("Developed By:").font(.headline)
                            VStack(alignment: .leading){
                                Text("Berto Gonzalez")
                                Text("Sammy Gonzalez")
                                Text("Kendal Jones")
                                Text("Quinn Tonelli")
                                Text("Natalie Zoz")
                            }
                            .font(.subheadline)
                            .padding(.leading, 8.0)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Data Collected By:").font(.headline)
                            Text("Kenneth Clifton")
                                .font(.subheadline)
                                .padding([.leading, .bottom], 8.0)
                            
                            Text("Created For:").font(.headline)
                            VStack(alignment: .leading){
                                Text("Peter Drake")
                                Text("CS-488-01 Sof. Dev. 2023")
                            }
                            .font(.subheadline)
                            .padding(.leading, 8)
                        }.padding(.leading, 30.0)
                        
                    }
                    Spacer()
                    if ishiddenp2{
                        Text("Fish are friends, NOT FOOD").font(.callout)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading){
                        HStack{
                            Spacer()
                            Button("Explore FishBook") {
                                fishlist.toggle()
                            }
                            Spacer()
                            Button("Random Fish") {
                                randfish.toggle()
                            }
                            Spacer()
                        }.buttonStyle( .bordered)
                    }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        Frontview()
    }
}

struct HomePage_ImageSlider: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var images = ["Chaetodon vagabundus", "Plectorhinchus albovittatus", "Heteroconger hassi"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { item in
                GeometryReader {proxy in
                    Image(item)
                        .resizable()
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .shadow(color: colorScheme == .dark ? Color.white : Color.black, radius: 5)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3)
                        .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
