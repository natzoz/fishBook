//
//  Fish.swift
//  FishBook
//
//  Created by cs-488-01 on 2/16/23.
//

import Foundation

struct Fish: Identifiable {
    var id: Int64
    
    var commonName: String
    var scientificName: String
    var group: String
    var family: String
    var habitat: String
    var occurence: String
    var description: String
    
    var imageName: String { return scientificName}
}

