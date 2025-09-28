//
//  ContentView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/26/25.
//

/*
 NEEDED:
 - Method to delete flashcards within decks
 - Method to delete a deck
 
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var store = FlashcardStore()
    @State private var showingAddDeck = false
    @State private var showingRemoveDeck = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.decks) { deck in
                    NavigationLink(destination: DeckDetailView(deck: deck, store: store)) {
                        Text(deck.name)
                    }
                }
            }
            .navigationTitle("Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingRemoveDeck = true }){
                        Image(systemName: "trash")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddDeck = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        // Attach sheets to the main view so they receive the correct bindings
        .sheet(isPresented: $showingAddDeck) {
            AddDeckView { name in
                store.addDeck(name: name)
            }
        }
        .sheet(isPresented: $showingRemoveDeck) {
            RemoveDeckView(decks: $store.decks)
        }
    }
}

#Preview{
    ContentView()
}
