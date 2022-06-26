//
//  EditView.swift
//  Day77Challenge
//
//  Created by Eric Di Gioia on 6/12/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContentView.ViewModel // viewModel passed in from parent View
    
    @State private var chosenImage: UIImage? = nil
    @State private var inputName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                if chosenImage != nil {
                    Image(uiImage: chosenImage!)
                        .resizable()
                        .scaledToFit()
                } else {
                    Button("Add image") {
                        viewModel.showingImagePicker = true
                    }
                }
                
                TextField("Assign a name", text: $inputName)
            }
            .navigationTitle("Add item")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addItem(image: chosenImage, name: inputName, coordinates: viewModel.locationFetcher.lastKnownLocation)
                        dismiss()
                    }
                    .disabled((chosenImage == nil) || (inputName.trimmingCharacters(in: .whitespaces).isEmpty))
                }
            }
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $chosenImage)
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
