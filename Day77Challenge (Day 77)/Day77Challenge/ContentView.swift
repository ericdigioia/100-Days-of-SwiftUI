//
//  ContentView.swift
//  Day77Challenge
//
//  Created by Eric Di Gioia on 6/12/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        HStack {
                            item.displayImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            
                            Text(item.name)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .navigationBarTitle("Day 77 Challenge")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showingEditView = true
                    } label: {
                        Label("Add photo", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                print("starting location fetcher...")
                viewModel.locationFetcher.start()
            }
            .sheet(isPresented: $viewModel.showingEditView) {
                EditView()
            }
            .environmentObject(viewModel) // so we can pass the viewModel into the EditView as an @EnviromentObject
        }
    }
    
}

//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .preferredColorScheme(.dark)
//    }
//}
