//
//  DeckDetailView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
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
    
    var body: some View {
        VStack {
            if !deck.flashcards.isEmpty {
                let card = deck.flashcards[currentIndex]
                
                Text(showingAnswer ? card.answer : card.question)
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(width: 300, height: 180)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding()
                
                if !showingAnswer {
                    Button("Show Answer") {
                        showingAnswer = true
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    HStack {
                        Button("I Got It Wrong") {
                            goToNextCard()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("I Got It Right") {
                            goToNextCard()
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddCard = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        // Present add / remove sheets from the view so they have the correct bindings
        .sheet(isPresented: $showingAddCard) {
            AddFlashcardView { question, answer in
                store.addFlashcard(to: deck, question: question, answer: answer)
            }
        }
        .sheet(isPresented: $showingRemoveFlashcards) {
            RemoveFlashcardView(flashcards: flashcardsBinding) { deleted, offsets in
                // capture for undo
                lastDeletedCards = deleted
                lastDeletedOffsets = offsets
                // show undo option
                showingUndoAlert = true
            }
        }
        .alert("Cards deleted", isPresented: $showingUndoAlert) {
            Button("Undo", role: .cancel) {
                undoDeletion()
            }
            Button("OK", role: .none) {
                // clear buffer if user accepts deletion
                lastDeletedCards = []
                lastDeletedOffsets = IndexSet()
            }
        } message: {
            Text("Flashcards were deleted. Undo?")
        }
    }

    /// Binding that points to this deck's flashcards inside the store.
    /// Falls back to an empty constant array if the deck isn't found.
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

    // If the user chooses undo, reinsert deleted cards at the appropriate offsets
    private func undoDeletion() {
        guard !lastDeletedCards.isEmpty,
              let idx = store.decks.firstIndex(where: { $0.id == deck.id }) else { return }

        // Rebuild the deck's flashcards inserting each deleted card at the first offset
        // Note: For simplicity, insert deleted items at the start of the first offset.
        var cards = store.decks[idx].flashcards
        // Sort offsets and pair them with deleted items; insert in increasing order
        let sortedOffsets = lastDeletedOffsets.sorted()
        for (i, offset) in sortedOffsets.enumerated() {
            let item = i < lastDeletedCards.count ? lastDeletedCards[i] : lastDeletedCards.last!
            let insertIndex = min(offset, cards.count)
            cards.insert(item, at: insertIndex)
        }
        store.decks[idx].flashcards = cards
        // clear the undo buffer
        lastDeletedCards = []
        lastDeletedOffsets = IndexSet()
    }
    
    private func goToNextCard() {
        showingAnswer = false
        if currentIndex < deck.flashcards.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0 // loop back
        }
    }
}
