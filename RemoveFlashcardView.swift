//
//  RemoveFlashcardView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//



import SwiftUI

struct RemoveFlashcardView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Use the defined FlashcardStruct type
    // The @Binding connects this view to the array of flashcards stored in a parent view.
    @Binding var flashcards: [FlashcardStruct]
    
    var body: some View {
        NavigationView {
            List {
                // The ForEach now iterates over your FlashcardStruct array
                ForEach(flashcards) { card in
                    VStack(alignment: .leading) {
                        Text(card.question)
                            .font(.headline)
                        // Display the answer as secondary text
                        Text(card.answer)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                // .onDelete enables swipe-to-delete and is essential for the EditButton
                .onDelete(perform: deleteFlashcards)
            }
            .navigationTitle("Remove Flashcards")
            .toolbar {
                // Done button to dismiss the view
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                // EditButton enables selection mode for deletion
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    /// Function to handle the list deletion operation.
    /// It receives an IndexSet of items to be removed.
    func deleteFlashcards(offsets: IndexSet) {
        // This line updates the bound array, deleting the selected elements.
        flashcards.remove(atOffsets: offsets)
    }
}

// MARK: - Preview

#Preview {
    // Container needed to hold the @State array for the @Binding to work in the preview
    struct RemoveFlashcardViewContainer: View {
        @State private var cards: [FlashcardStruct] = [
            FlashcardStruct(question: "What is the capital of France?", answer: "Paris"),
            FlashcardStruct(question: "Who wrote 'Romeo and Juliet'?", answer: "Shakespeare"),
            FlashcardStruct(question: "Formula for water?", answer: "H₂O")
        ]
        
        var body: some View {
            RemoveFlashcardView(flashcards: $cards)
        }
    }
    
    return RemoveFlashcardViewContainer()
}
