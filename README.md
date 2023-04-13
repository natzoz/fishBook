# FishBook

# Description
FishBook is an iOS and macOS app designed for storing and displaying fish species data collected from Tanzanian reef fishes.

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
  2. Add your Apple ID to Accounts preferences
  3. Create a personal team
  4. Be sure to select Automatically manage signing in the Signing and Capabilities tab of the project
  5. Connect your device to the computer via lightning cable and add the device by navigating to Window > Devices and Simulators
  6. Select your device in the build toolbar and run the project

### On your device:
  1. [Enable developer mode](https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device) by navigating to Settings > Privacy & Security > Developer Mode
  2. Trust the developer by navigating to Settings > General > VPN & Device Management > Trust

### Deployment Targets:
* iOS 16.0
* macOS 12.6

# Authors and Acknowledgments
Created by:
* Berto Gonzalez
* Sammy Gonzalez
* Kendal Jones
* Quinn Tonelli
* Natalie Zoz

Data Collected by:
Ken Cliffton

Created for CS-488 Software Development Spring 2023 at Lewis & Clark College
