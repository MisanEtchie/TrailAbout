//
//  LocationsPreviewView.swift
//  TrailAbout
//
//  Created by Misan on 8/28/24.
//

import SwiftUI

struct LocationsPreviewView: View {
    
    let location: Location
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    var body: some View {
        VStack {
            HStack (alignment: .bottom, spacing: 0) {
                VStack( alignment: .leading, spacing: 16.0) {
                    
                    previewImage
                    
                    previewTitle
                }
                
                Spacer()
                
                VStack (spacing: 8) {

                    learnMoreButton
                    
                    
                    
                    //nextButton

                }
            }.padding(20)
            
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.ultraThinMaterial)
                        .offset(y: 60)
                )
            .cornerRadius(30)
            
            statusButton
        }
    }
}




extension LocationsPreviewView  {
    private var previewImage: some View {
        ZStack{
            if let imageName = location.imageNames.first
            {
                Image(imageName)
                    .resizable()
                
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
            }
        }
        .padding(6)
        
        .background(Color.white)
        .cornerRadius(26)
        
        .onTapGesture {
            vm.showNextLocation(location: location)
        }
    }
    
    private var previewTitle: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(location.cityName)
            
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
    
    private var learnMoreButton: some View {
        Button {
            vm.sheetLocation = location
        } label: {
            Text("Learn More")
                .font(.headline)
                .padding(4)
                .frame(width: 125)
                
        }
        .buttonStyle(.borderedProminent)
        .cornerRadius(30)
    }
    
    private var statusButton: some View {
        HStack {
                    // "Visited" Button
                    Button(action: {
                        vm.createNewPost = true
                        vm.status = .visited
                    }) {
                        Text("🤩 Visited")
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            //.background(Color("AccentColor"))
                            .foregroundColor(Color("InverseColor"))
                            .background(.ultraThinMaterial)
                            .cornerRadius(25)
                    }

                    // "Wants to Go" Button
                    Button(action: {
                        vm.createNewPost = true
                        vm.status = .wantsToGo
                    }) {
                        Text("🧳 Want to Go")
                            .fontWeight(.medium)
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            //.background(Color.blue)
                            .background(.ultraThinMaterial)
                            .foregroundColor(Color("InverseColor"))
                            .cornerRadius(25)
                    }
                }
       // .padding(.horizontal, 15)
    }
    
    private var nextButton: some View {
        Button {
            //LocationsViewModel.showNextLocation(location:  location)
            vm.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .padding(4)
                .frame(width: 125)
        }
        .buttonStyle(.bordered)
        .cornerRadius(30)
    }
}


#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        LocationsPreviewView(location: LocationsDataService.locations.first!).padding()
    }.environmentObject(LocationsViewModel())
}
