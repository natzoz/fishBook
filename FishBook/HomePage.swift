//
//  HomePage.swift
//  FishBook
//
//  Created by cs-488-01 on 3/14/23.
//

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
                    Button("HomePage") {
                        fishlist.toggle()
                    }.buttonStyle( .bordered)
                }
            }else{
                Spacer()
                VStack{
                    Text("FishBook").font(.title)
                    HomePage_ImageSlider()
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3)
                        .onTapGesture{ishidden.toggle()}
                    if ishidden{
                        VStack{
                            Text("Welcome to the world of FISH!!!")
                            Text("gulp gulp gulp").font(.caption)
                        }.onTapGesture {
                            ishiddenp2.toggle()
                        }
                    }
                    
                    Spacer()
                    HStack(alignment: .top){
                        VStack(alignment: .leading){
                            Text("Developed By:").bold()
                            VStack(alignment: .leading){
                                Text("Berto Gonzalez")
                                Text("Sammy Gonzalez")
                                Text("Kendal Jones")
                                Text("Quinn Tonelli")
                                Text("Natalie Zoz")
                            }.padding(.leading, 8.0)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Data Collector:").bold()
                            Text("Kenneth Clifton")
                                .padding(.leading, 8.0)
            
                            Text("Created For:").bold()
                            VStack(alignment: .leading){
                                Text("Peter Drake")
                                Text("CS-488-01 Sof. Dev.")
                            }.padding(.leading, 8)
                        }.padding(.leading, 30.0)
                        
                    }
                    Spacer()
                    if ishiddenp2{
                        Text("Here fish are friends, NOT FOOD").font(.callout)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading){
                        HStack{
                            Spacer()
                            Button("Explore our FishBook") {
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
    @State private var images = ["Chaetodon vagabundus", "Chaetodon madagascarensis", "Chaetodon interruptus"]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { item in
                GeometryReader {proxy in
                    Image(item)
                        .resizable()
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .shadow(radius: 10)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3)
                        .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
