//
//  ContentView.swift
//  UnitConverter
//
//  Created by Eric Di Gioia on 4/17/22.
//

import SwiftUI

struct ContentView: View {
    let tempUnits = ["Celcius", "Fahrenheit", "Kelvin"]
    let lengthUnits = ["meters", "kilometers", "feet", "yards", "miles"]
    let timeUnits = ["seconds", "minutes", "hours", "days"]
    let volumeUnits = ["milliliters", "liters", "cups", "pints", "gallons"]
    
    let feetIn1Meter = 3.2808
    let feetIn1Kilometer = 3280.8
    let cupsIn1Liter = 4.2268
    
    @State private var inputTemp = 0.0
    @State private var inputTempUnits = "Celcius"
    @State private var inputLength = 0.0
    @State private var inputLengthUnits = "meters"
    @State private var inputTime = 0.0
    @State private var inputTimeUnits = "seconds"
    @State private var inputVolume = 0.0
    @State private var inputVolumeUnits = "milliliters"
    
    private var outputTemp: Double {
        switch inputTempUnits {
        case "Celcius":
            switch outputTempUnits {
            case "Celcius": return inputTemp
            case "Fahrenheit": return (inputTemp*9/5)+32
            case "Kelvin": return inputTemp+273.15
            default: return 0
            }
        case "Fahrenheit":
            switch outputTempUnits {
            case "Celcius": return (inputTemp-32)*5/9
            case "Fahrenheit": return inputTemp
            case "Kelvin": return ((inputTemp-32)*5/9)+273.15
            default: return 0
            }
        case "Kelvin":
            switch outputTempUnits {
            case "Celcius": return inputTemp-273.15
            case "Fahrenheit": return ((inputTemp-273.15)*9/5)+32
            case "Kelvin": return inputTemp
            default: return 0
            }
        default: return 0
        }
    }
    @State private var outputTempUnits = "Celcius"
    private var outputLength: Double {
        switch inputLengthUnits{
        case "meters":
            switch outputLengthUnits{
            case "meters": return inputLength
            case "kilometers": return inputLength/1000
            case "feet": return inputLength*feetIn1Meter
            case "yards": return inputLength*feetIn1Meter/3
            case "miles": return inputLength*feetIn1Meter/5280
            default: return 0
            }
        case "kilometers":
            switch outputLengthUnits{
            case "meters": return inputLength*1000
            case "kilometers": return inputLength
            case "feet": return inputLength*feetIn1Kilometer
            case "yards": return inputLength*feetIn1Kilometer/3
            case "miles": return inputLength*feetIn1Kilometer/5280
            default: return 0
            }
        case "feet":
            switch outputLengthUnits{
            case "meters": return inputLength/feetIn1Meter
            case "kilometers": return inputLength/feetIn1Kilometer
            case "feet": return inputLength
            case "yards": return inputLength/3
            case "miles": return inputLength/5380
            default: return 0
            }
        case "yards":
            switch outputLengthUnits{
            case "meters": return inputLength*3/feetIn1Meter
            case "kilometers": return inputLength*3/feetIn1Kilometer
            case "feet": return inputLength*3
            case "yards": return inputLength
            case "miles": return inputLength/1760
            default: return 0
            }
        case "miles":
            switch outputLengthUnits{
            case "meters": return inputLength*1760*3/feetIn1Meter
            case "kilometers": return inputLength*1760*3/feetIn1Kilometer
            case "feet": return inputLength*1760*3
            case "yards": return inputLength*1760
            case "miles": return inputLength
            default: return 0
            }
        default: return 0
        }
    }
    @State private var outputLengthUnits = "meters"
    private var outputTime: Double {
        switch inputTimeUnits{
        case "seconds":
            switch outputTimeUnits{
            case "seconds": return inputTime
            case "minutes": return inputTime/60
            case "hours": return inputTime/60/60
            case "days": return inputTime/60/60/24
            default: return 0
            }
        case "minutes":
            switch outputTimeUnits{
            case "seconds": return inputTime*60
            case "minutes": return inputTime
            case "hours": return inputTime/60
            case "days": return inputTime/60/24
            default: return 0
            }
        case "hours":
            switch outputTimeUnits{
            case "seconds": return inputTime*60*60
            case "minutes": return inputTime*60
            case "hours": return inputTime
            case "days": return inputTime/24
            default: return 0
            }
        case "days":
            switch outputTimeUnits{
            case "seconds": return inputTime*34*60*60
            case "minutes": return inputTime*24*60
            case "hours": return inputTime*24
            case "days": return inputTime
            default: return 0
            }
        default: return 0
        }
    }
    @State private var outputTimeUnits = "seconds"
    private var outputVolume: Double {
        switch inputVolumeUnits{
        case "milliliters":
            switch outputVolumeUnits{
            case "milliliters": return inputVolume
            case "liters": return inputVolume/1000
            case "cups": return inputVolume/1000*cupsIn1Liter
            case "pints": return inputVolume/1000*cupsIn1Liter/2
            case "gallons": return inputVolume/1000*cupsIn1Liter/16
            default: return 0
            }
        case "liters":
            switch outputVolumeUnits{
            case "milliliters": return inputVolume*1000
            case "liters": return inputVolume
            case "cups": return inputVolume*cupsIn1Liter
            case "pints": return inputVolume*cupsIn1Liter/2
            case "gallons": return inputVolume*cupsIn1Liter/16
            default: return 0
            }
        case "cups":
            switch outputVolumeUnits{
            case "milliliters": return inputVolume/cupsIn1Liter*1000
            case "liters": return inputVolume/cupsIn1Liter
            case "cups": return inputVolume
            case "pints": return inputVolume/2
            case "gallons": return inputVolume/16
            default: return 0
            }
        case "pints":
            switch outputVolumeUnits{
            case "milliliters": return inputVolume*2000/cupsIn1Liter
            case "liters": return inputVolume*2/cupsIn1Liter
            case "cups": return inputVolume*2
            case "pints": return inputVolume
            case "gallons": return inputVolume/8
            default: return 0
            }
        case "gallons":
            switch outputVolumeUnits{
            case "milliliters": return inputVolume*16000/cupsIn1Liter
            case "liters": return inputVolume*16/cupsIn1Liter
            case "cups": return inputVolume*16
            case "pints": return inputVolume*8
            case "gallons": return inputVolume
            default: return 0
            }
        default: return 0
        }
    }
    @State private var outputVolumeUnits = "milliliters"
    
    @FocusState private var tempIsFocused: Bool
    @FocusState private var lengthIsFocused: Bool
    @FocusState private var timeIsFocused: Bool
    @FocusState private var volumeIsFocused: Bool
    
    func unfocusAll(){
        
    }
    
    var body: some View {
        NavigationView{
            Form{
                
                Section{
                    TextField("Input temperature", value: $inputTemp, format: .number)
                    .keyboardType(.numberPad)
                    .focused($tempIsFocused)
                    Picker("Input temperature units", selection: $inputTempUnits){
                        ForEach(tempUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Temperature")
                }
                
                Section{
                    Text(outputTemp, format: .number)
                    Picker("Output temperature units", selection: $outputTempUnits){
                        ForEach(tempUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output Temperature")
                }
                
                Section{
                    TextField("Input length", value: $inputLength, format: .number)
                    .keyboardType(.numberPad)
                    .focused($lengthIsFocused)
                    Picker("Input length units", selection: $inputLengthUnits){
                        ForEach(lengthUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Length")
                }
                
                Section{
                    Text(outputLength, format: .number)
                    Picker("Output length units", selection: $outputLengthUnits){
                        ForEach(lengthUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output Length")
                }
                
                Section{
                    TextField("Input time", value: $inputTime, format: .number)
                    .keyboardType(.numberPad)
                    .focused($timeIsFocused)
                    Picker("Input time units", selection: $inputTimeUnits){
                        ForEach(timeUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Time")
                }
                
                Section{
                    Text(outputTime, format: .number)
                    Picker("Output time units", selection: $outputTimeUnits){
                        ForEach(timeUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output Time")
                }
                
                Section{
                    TextField("Input volume", value: $inputVolume, format: .number)
                    .keyboardType(.numberPad)
                    .focused($volumeIsFocused)
                    Picker("Input volume units", selection: $inputVolumeUnits){
                        ForEach(volumeUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Input Volume")
                }
                
                Section{
                    Text(outputVolume, format: .number)
                    Picker("Output volume units", selection: $outputVolumeUnits){
                        ForEach(volumeUnits, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Output Volume")
                } footer: {
                    Text("@2022 Eric Di Gioia")
                }
                
            }
            .navigationTitle("Unit Converter")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){ // unfocus all
                        tempIsFocused = false
                        lengthIsFocused = false
                        timeIsFocused = false
                        volumeIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
