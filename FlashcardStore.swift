//  FlashcardStore.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//  Edited on 9/28/25 
//

import Foundation
import Combine

class FlashcardStore: ObservableObject {
   
    @Published var decks: [FlashcardDeck] = [] {
           didSet {
               save()
           }
       }
    
    /// Persisted per-deck review progress: deck id -> last index
    @Published var reviewProgress: [UUID: Int] = [:] {
        didSet {
            saveReviewProgress()
        }
    }
       
       private let saveKey = "decks"
       
       init() {
           load()
       }
       
       func addDeck(name: String) {
           let newDeck = FlashcardDeck(name: name, flashcards: [])
           decks.append(newDeck)
       }
       
    func addFlashcard(to deck: FlashcardDeck, question: String, answer: String, cardColorHex: String ) {
           if let index = decks.firstIndex(where: { $0.id == deck.id }) {
               var deckToUpdate = decks[index]
               let newCard = FlashcardStruct(question: question, answer: answer, cardColorHex: cardColorHex)
               deckToUpdate.flashcards.append(newCard)
               decks[index] = deckToUpdate
           }
       }
       
       private func save() {
           if let encoded = try? JSONEncoder().encode(decks) {
               UserDefaults.standard.set(encoded, forKey: saveKey)
           }
       }
       
       private let reviewProgressKey = "reviewProgress"
       
       private func saveReviewProgress() {
           if let encoded = try? JSONEncoder().encode(reviewProgress) {
               UserDefaults.standard.set(encoded, forKey: reviewProgressKey)
           }
       }
       
       private func load() {
           if let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([FlashcardDeck].self, from: data) {
               decks = decoded
           }
           // load review progress
           if let data = UserDefaults.standard.data(forKey: reviewProgressKey),
              let decoded = try? JSONDecoder().decode([UUID: Int].self, from: data) {
               reviewProgress = decoded
           }
       }
    
}

