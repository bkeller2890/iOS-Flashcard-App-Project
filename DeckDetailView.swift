//
//  DeckDetailView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//  Edited on 9/29/2025
//

import SwiftUI

struct DeckDetailView: View {
    var deck: FlashcardDeck
    @ObservedObject var store: FlashcardStore
    
    @State private var currentIndex = 0
    @State private var showingAnswer = false
    @State private var showingAddCard = false
    @State private var showingRemoveFlashcards = false
    @State private var lastDeletedCards: [FlashcardStruct] = []
    @State private var lastDeletedOffsets: IndexSet = IndexSet()
    @State private var showingUndoAlert = false
    
    @State private var shuffleEnabled = false
    @State private var shuffledCards: [FlashcardStruct] = []
    
    @State private var showFavoritesOnly = false
    
    var body: some View {
        VStack {
            let allCards = shuffleEnabled ? shuffledCards : deck.flashcards
            let cards = showFavoritesOnly ? allCards.filter { $0.isFavorite } : allCards
            
            if !cards.isEmpty {
                let card = cards[currentIndex]
                
                ZStack(alignment: .topTrailing) {
                    Text(showingAnswer ? card.answer : card.question)
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 180)
                        .background(card.cardColor)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding()
                    
                    // ⭐ Favorite toggle button
                    Button(action: { toggleFavorite(for: card) }) {
                        Image(systemName: card.isFavorite ? "star.fill" : "star")
                            .foregroundColor(card.isFavorite ? .yellow : .gray)
                            .padding()
                    }
                }
                
                if !showingAnswer {
                    Button("Show Answer") {
                        showingAnswer = true
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    HStack {
                        Button("I Got It Wrong") {
                            goToNextCard(cards: cards)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("I Got It Right") {
                            goToNextCard(cards: cards)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else {
                Text("No flashcards yet. Add some!")
            }
        }
        .navigationTitle(deck.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showingRemoveFlashcards = true }) {
                    Image(systemName: "trash")
                }
            }
            ToolbarItem(placement: .principal) {
                NavigationLink {
                    let progressBinding = Binding<Int>(
                        get: { store.reviewProgress[deck.id] ?? 0 },
                        set: { store.reviewProgress[deck.id] = $0 }
                    )
                    ReviewView(deck: deck, currentIndex: progressBinding)
                } label: {
                    Text("Review")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: { showingAddCard = true }) {
                        Image(systemName: "plus")
                    }
                    
                    Button(action: toggleShuffle) {
                        Image(systemName: shuffleEnabled ? "shuffle.circle.fill" : "shuffle.circle")
                    }
                    
                    // NEW filter favorites button
                    Button(action: { showFavoritesOnly.toggle() }) {
                        Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddCard) {
            AddFlashcardView { question, answer, cardColorHex in
                store.addFlashcard(to: deck,
                                   question: question,
                                   answer: answer,
                                   cardColorHex: cardColorHex)
            }
        }
        .sheet(isPresented: $showingRemoveFlashcards) {
            RemoveFlashcardView(flashcards: flashcardsBinding) { deleted, offsets in
                lastDeletedCards = deleted
                lastDeletedOffsets = offsets
                showingUndoAlert = true
            }
        }
        .alert("Cards deleted", isPresented: $showingUndoAlert) {
            Button("Undo", role: .cancel) { undoDeletion() }
            Button("OK", role: .none) {
                lastDeletedCards = []
                lastDeletedOffsets = IndexSet()
            }
        } message: {
            Text("Flashcards were deleted. Undo?")
        }
        .onAppear {
            shuffledCards = deck.flashcards.shuffled()
        }
    }
    
    private var flashcardsBinding: Binding<[FlashcardStruct]> {
        if let idx = store.decks.firstIndex(where: { $0.id == deck.id }) {
            return Binding(
                get: { store.decks[idx].flashcards },
                set: { store.decks[idx].flashcards = $0 }
            )
        } else {
            return .constant([])
        }
    }
    
    private func undoDeletion() {
        guard !lastDeletedCards.isEmpty,
              let idx = store.decks.firstIndex(where: { $0.id == deck.id }) else { return }
        var cards = store.decks[idx].flashcards
        let sortedOffsets = lastDeletedOffsets.sorted()
        for (i, offset) in sortedOffsets.enumerated() {
            let item = i < lastDeletedCards.count ? lastDeletedCards[i] : lastDeletedCards.last!
            let insertIndex = min(offset, cards.count)
            cards.insert(item, at: insertIndex)
        }
        store.decks[idx].flashcards = cards
        lastDeletedCards = []
        lastDeletedOffsets = IndexSet()
    }
    
    private func goToNextCard(cards: [FlashcardStruct]) {
        showingAnswer = false
        if currentIndex < cards.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
            if shuffleEnabled {
                shuffledCards = deck.flashcards.shuffled()
            }
        }
    }
    
    private func toggleShuffle() {
        shuffleEnabled.toggle()
        currentIndex = 0
        if shuffleEnabled {
            shuffledCards = deck.flashcards.shuffled()
        }
    }
    
    // ⭐ Toggle favorite state
    private func toggleFavorite(for card: FlashcardStruct) {
        guard let deckIndex = store.decks.firstIndex(where: { $0.id == deck.id }),
              let cardIndex = store.decks[deckIndex].flashcards.firstIndex(where: { $0.id == card.id }) else {
            return
        }
        store.decks[deckIndex].flashcards[cardIndex].isFavorite.toggle()
    }
}
