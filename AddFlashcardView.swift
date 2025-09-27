//
//  AddFlashcardView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//

import SwiftUI

struct AddFlashcardView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var question = ""
    @State private var answer = ""
    
    /// Called when user taps Save
    var onSave: (String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question")) {
                    TextField("Enter question", text: $question)
                }
                
                Section(header: Text("Answer")) {
                    TextField("Enter answer", text: $answer)
                }
            }
            .navigationTitle("New Flashcard")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !question.isEmpty && !answer.isEmpty {
                            onSave(question, answer)
                            dismiss()
                        }
                    }
                    .disabled(question.isEmpty || answer.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddFlashcardView { question, answer in
        print("Saved card:", question, answer)
    }
}

