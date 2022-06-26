//
//  ContentView.swift
//  Instafilter
//
//  Created by Eric Di Gioia on 6/1/22.
//

import CoreImage // access to CI APIs
import CoreImage.CIFilterBuiltins // modern Swifty CI APIs
import SwiftUI
 
struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity: Float = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone() // specify GENERIC CIFilter
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select an image")
                        .foregroundColor(.white)
                        .font(.headline)
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                HStack {
                    Text("Insensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProcessing() }
                }
                .padding()
                
                HStack {
                    Button("Change filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Group {
                    Button("Crystalize") { setFilter(CIFilter.crystallize()) }
                    Button("Edges") { setFilter(CIFilter.edges()) }
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                    Button("Gamma Adjust") { setFilter(CIFilter.gammaAdjust()) }
                    Button("Box Blur") { setFilter(CIFilter.boxBlur()) }
                }
                Group {
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }
    
    func loadImage() { // convert UIImage to Image
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage) // convert UIImage to CGImage for CI processing
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey) // load image into CI Filter
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else { return } // make sure optional var contains data
        
        let imageSaver = ImageSaver() // initialize an imageSaver instance
        imageSaver.successHandler = { print("Success!") } // define its success handler
        imageSaver.errorHandler = { print("Oops! \($0.localizedDescription)") } // this $0 is the error
        imageSaver.writeToPhotoAlbum(image: processedImage) // save the image to photo library
    }
    
    func applyProcessing() { // process image loaded into currentFilter and then output to 'image'
        //currentFilter.intensity = filterIntensity // This only works for a sepiatone filter, not a generic one
        let inputKeys = currentFilter.inputKeys // what does the current filter support?
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200 + 1, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 10 + 1, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIAttributeTypeScalar) {
            currentFilter.setValue(filterIntensity, forKey: kCIAttributeTypeScalar)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
            
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) { // get CGImage (CI image)
            let uiImage = UIImage(cgImage: cgimg) // convert CGImage to UIImage (UIKit image)
            image = Image(uiImage: uiImage) // convert UIImage to Image (Swift image) (to display)
            processedImage = uiImage // (to save)
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage() // this function then calls applyProcessing()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
