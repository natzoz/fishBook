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
    var body: some View{
        return Group{
            if randfish {
                VStack{
                    FishDetailPage(fish: allFishData.fishes.randomElement()!)
                    Button("Go Back") {
                        randfish.toggle()
                    }                }
            }else{
                ZStack{
                    Color.orange.ignoresSafeArea()
                    
                    VStack{
                        
                        
                    }
                
                VStack{
                    HStack{
                        Spacer()
                        Button("Random fish") {
                            randfish.toggle()
                        }
                        Spacer()
                        Button("Explore our FishBook") {
                            fishlist.toggle()
                        }
                        Spacer()
                    }
                    .buttonStyle(.bordered)
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
