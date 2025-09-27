//  FlashcardStore.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//

import Foundation
internal import Combine

class FlashcardStore: ObservableObject {
   
    @Published var decks: [FlashcardDeck] = [] {
           didSet {
               save()
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
       
       func addFlashcard(to deck: FlashcardDeck, question: String, answer: String) {
           if let index = decks.firstIndex(where: { $0.id == deck.id }) {
               let newCard = FlashcardStruct(question: question, answer: answer)
               decks[index].flashcards.append(newCard)
           }
       }
       
       private func save() {
           if let encoded = try? JSONEncoder().encode(decks) {
               UserDefaults.standard.set(encoded, forKey: saveKey)
           }
       }
       
       private func load() {
           if let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([FlashcardDeck].self, from: data) {
               decks = decoded
           }
       }
    
}
