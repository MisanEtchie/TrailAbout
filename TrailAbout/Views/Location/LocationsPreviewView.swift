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
        HStack (alignment: .bottom, spacing: 0) {
            VStack( alignment: .leading, spacing: 16.0) {
                
                previewImage
                
                previewTitle
            }
            
            Spacer()
            
            VStack (spacing: 8) {

                learnMoreButton
                
                nextButton

            }
        }.padding(20)
        
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .offset(y: 60)
            )
            .cornerRadius(25)
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
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.borderedProminent)
    }
    
    
    private var nextButton: some View {
        Button {
            //LocationsViewModel.showNextLocation(location:  location)
            vm.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(.bordered)
    }
}


#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        LocationsPreviewView(location: LocationsDataService.locations.first!).padding()
    }.environmentObject(LocationsViewModel())
}
