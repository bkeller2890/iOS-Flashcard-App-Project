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
            Button(action: { showingAddCard = true }) {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $showingAddCard) {
                AddFlashcardView { question, answer in
                    store.addFlashcard(to: deck, question: question, answer: answer)
                }
            }
        }
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
