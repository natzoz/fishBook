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
                    ImageSlider()
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3)
                    
                        VStack{
                            Text("Welcome to the world of FISH!!!")
                            Text("gulp gulp gulp").font(.caption)
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
                            VStack{
                                Text("Peter Drake")
                                Text("CS-488-01 Sof. Dev.")
                            }.padding(.leading, 8)
                        }
                    }.padding(.trailing, 100)
                    Spacer()
                    
                    Text("Here fish are friends, NOT FOOD").font(.callout)
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
