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
    // Persist the user's appearance choice across launches
    // Use a tri-state appearance setting: "system", "light", "dark"
    @AppStorage("appearance") private var appearance: String = "system"
    @State private var animateAppearanceChange = false
    
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
                    HStack(spacing: 12) {
                        NavigationLink(destination: AppearanceView()) {
                            Image(systemName: "paintpalette")
                        }

                        Button(action: { showingAddDeck = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        // Apply the preferred color scheme from the persisted setting
        // Map stored appearance string to preferredColorScheme (.none for system)
        .preferredColorScheme(
            appearance == "dark" ? .dark : (appearance == "light" ? .light : nil)
        )
        // Simple fade animation overlay when appearance changes
        .overlay(
            Color.black.opacity(animateAppearanceChange ? 0.15 : 0)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.25), value: animateAppearanceChange)
        )
        .onChange(of: appearance) { _ in
            animateAppearanceChange = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                animateAppearanceChange = false
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
