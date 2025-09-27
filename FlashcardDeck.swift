//
//  FlashcardDeck.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//

import Foundation

struct FlashcardDeck : Identifiable, Codable {
    let id: UUID
    var name: String
    var flashcards: [FlashcardStruct]
    
    init(id: UUID = UUID(), name: String, flashcards: [FlashcardStruct]) {
        self.id = id
        self.name = name
        self.flashcards = flashcards
    }
}
