//
//  AddDeckView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/27/25.
//

import SwiftUI

struct AddDeckView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    
    /// Called when user taps Save
    var onSave: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Name")) {
                    TextField("Enter deck name", text: $name)
                }
            }
            .navigationTitle("New Deck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !name.isEmpty {
                            onSave(name)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddDeckView { name in
        print("Saved deck:", name)
    }
}
