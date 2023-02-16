//
//  ContentView.swift
//  FishBook
//
//  Created by cs-488-01 on 2/16/23.
//

import SwiftUI

struct HomePage: View {
    var fishes: [Fish] = [
    Fish(commonName: "Butterfly Fish1", scientificName: "Heniochus monocerus", group: "test", family: "test", habitat: "Coral dominated", occurence: "test", description: "Description"),
    Fish(commonName: "Butterfly Fish2", scientificName: "Forcipiger flaviventris", group: "test", family: "test", habitat: "Coral dominated", occurence: "test", description: "Description"),
    Fish(commonName: "Butterfly Fish3", scientificName: "Heniochus acuminatus", group: "test", family: "test", habitat: "Coral dominated", occurence: "uncommon", description: "Description"),
    Fish(commonName: "Butterfly Fish4", scientificName: "Chaetodon zanzibarensis", group: "test", family: "test", habitat: "Coral dominated", occurence: "uncommon", description: "Description"),
    Fish(commonName: "Butterfly Fish5", scientificName: "Chaetodon xanthocephalus", group: "test", family: "test", habitat: "Coral dominated", occurence: "uncommon", description: "Description"),
    Fish(commonName: "Butterfly Fish6", scientificName: "Chaetodon vagabundus", group: "test", family: "test", habitat: "Coral dominated", occurence: "uncommon", description: "Description")
    ]
    
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
