//
//  ContentView.swift
//  Bookworm
//
//  Created by Eric Di Gioia on 5/19/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc // to edit data
    @FetchRequest(sortDescriptors: [ // when fetching book array from Core Data,
        SortDescriptor(\.title), // first sort by title
        SortDescriptor(\.author) // if same title, sort by author
    ]) var books: FetchedResults<Book> // to show data, put fetched array of Books into var 'books'
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack {
                                Text(book.title ?? "Unknown title")
                                    .font(.headline)
                                    .foregroundColor(book.rating == 1 ? .red : .primary)
                                
                                Text(book.author ?? "Unknown author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
    
