//
//  ContentView.swift
//  FishBook
//
//  Created by cs-488-01 on 2/16/23.
//

import SwiftUI

struct HomePage: View {
    var fishes: [Fish] = []
    
    var body: some View {
        NavigationView {
            List(fishes) { fish in
                FishListCell(fish: fish)
            }
            .navigationTitle("Fish Book")
        }
    }
}

struct FishListCell: View {
    var fish: Fish
    
    var body: some View {
        NavigationLink(destination: FishDetailPage(fish: fish)) {
            Image(fish.imageName)
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text(fish.commonName)
                Text(fish.scientificName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(fishes: testData)
    }
}
