# FishBook
FishBook is an iOS and macOS app designed for storing and displaying fish species data collected from coral reef-associated fishes in the nearshore waters of northern Tanzania.

# Prerequisites
* Xcode 14.3
* Swift 5.7.2

# Package Dependencies
* SQLite.swift

# Updating the Stored Data
Updates to the images and fish.csv file can be made through the [fish_book_editing repository](https://github.com/quinntonelli/fish_book_editing).

### To update the database:
  1. Open the fish.csv file in GitHub
  2. Click the pencil, “edit” button to directly edit the data
  3. Save the changes and they will be updated in the app after 12 hours

### To update the images:
  1. Open the fish_photos folder in GitHub
  2. Select Add file > Upload files and choose images to upload
  3. Then select Commit changes
  4. Changes will be updated in the app after 12 hours
  
# Installation
Installation of the app is limited to the free provisioning process which allows users to install the app without a paid developer account. To temporarily install the app for 7 days, follow these [instructions](https://help.apple.com/xcode/mac/current/#/dev60b6fbbc7):

  1. Download and open the FishBook Xcode project in Xcode
  2. Add your Apple ID to "Accounts preferences"
  3. Create a personal team
  4. Be sure to select "Automatically manage signing" in the "Signing and Capabilities" tab of the project
  5. Connect your device to the computer via lightning cable and add the device by navigating to Window > Devices and Simulators
  6. Select your device in the build toolbar and run the project

### On your device:
  1. [Enable developer mode](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device) by navigating to Settings > Privacy & Security > Developer Mode
  2. Trust the developer by navigating to Settings > General > VPN & Device Management > Trust

### Deployment Targets:
* iOS 16.0
* macOS 12.6

# Code Documentation
### Fish.swift
Fish object used for storing information about each fish.
```swift
struct Fish: Hashable {
    var id: Int64
    
    var commonName: String
    var scientificName: String
    var group: String
    var family: String
    var habitat: String
    var occurrence: String
    var description: String
    
    var imageName: String { return scientificName}
}
```
### FishData.swift
Observable object used for getting list of fishes and fish families
```swift
class FishData : ObservableObject{
    @Published var fishes: [Fish]
    @Published var families: [String]
    
    init(fishes: [Fish] = [], families: [String] = []) {
        self.fishes = fishes
        self.families = families
    }
}

let allFishData = FishData(fishes: FishDataStore.share.getAllFish(), families: FishDataStore.share.getAllFamilies())
```

### FishListPage.swift
Contains multiple views for displaying individual fish cells and filters for each category. Also contains sorting algorithms and search functions for filtering the lists.
```swift
var body: some View {
        NavigationStack {
            List {
                Picker("Filter", selection: $selectionFilter) {
                    ForEach(categoriesFilter, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Sort", selection: $selectionSort) {
                    if (selectionFilter != "All Fish") {
                        ForEach(categoriesSortShortened, id: \.self) {
                            Text($0)
                        }
                    } else {
                        ForEach(categoriesSort, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .pickerStyle(.menu)
                
                ForEach(allFishSearch, id: \.self) {fish in
                    FishListCell(fish: fish)
                }
                ForEach(habitatSearch, id: \.self) {habitat in
                    HabitatListCell(habitat: habitat)
                }
                ForEach(familySearch, id: \.self) {family in
                    FamilyListCell(family: family)
                }
                ForEach(occurrenceSearch, id: \.self) {occurrence in
                    OccurrenceListCell(occurrence: occurrence)
                }
                ForEach(groupSearch, id: \.self) {group in
                    GroupListCell(group: group)
                }
            }
            .navigationTitle("All Fish")
        }
        .searchable(text: $searchText)
    }
```

### FishDetailPage.swift
Contains the detailed view for displaying information about each fish including scientific name, common name, habitat, and occurence. Also has the ability to show multiple images and zoom in on each image.
```swift
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
```

### FishDataStore.swift
Contains the initialization for the fish database that contains the essential information for each fish. Also contains methods for pulling images and data from the files on the fish_book_editing repository.
```swift
static let DIR_FISH_DB = "FishDB"
    static let STORE_NAME = "fish.sqlite3"
    
    private let fishes = Table("fish")
    
    private let id = Expression<Int64>("id")
    private let commonName = Expression<String>("commonName")
    private let scientificName = Expression<String>("scientificName")
    private let group = Expression<String>("group")
    private let family = Expression<String>("family")
    private let habitat = Expression<String>("habitat")
    private let occurrence = Expression<String>("occurrence")
    private let description = Expression<String>("description")
    
    static let share = FishDataStore()
```

# Authors and Acknowledgments
Created by:
* Berto Gonzalez
* Sammy Gonzalez
* Kendal Jones
* Quinn Tonelli
* Natalie Zoz

Data Collected by:
Dr. Kenneth E. Clifton

Created for CS-488 Software Development Spring 2023 at Lewis & Clark College
