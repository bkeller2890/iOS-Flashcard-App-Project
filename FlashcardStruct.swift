//
//  FlashcardStruct.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/26/25.
//
import Foundation

struct FlashcardStruct: Identifiable, Codable {
    let id: UUID
    var question: String
    var answer: String
    
    init(id: UUID = UUID(), question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}


