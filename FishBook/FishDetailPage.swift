//
//  FishDetailPage.swift
//  FishBook
//
//  Created by cs-488-01 on 2/16/23.
//

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
                Text("Habitat: " + fish.habitat)
                Text("Description: " + fish.description)
            }
            .padding(.leading)
            Spacer()
        }
        .navigationTitle(fish.scientificName)
    }
}

struct FishDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FishDetailPage(fish: testData[0])
        }
    }
}
