//
//  ReviewView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/28/25.
//
import SwiftUI

struct ReviewView: View {
    var deck: FlashcardDeck
    @State private var currentIndex = 0
    @State private var reviewFinished = false
    
    var body: some View {
        VStack {
            if reviewFinished {
                // Finished Screen
                VStack(spacing: 20) {
                    Text("🎉 Review Finished!")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("You reviewed all \(deck.cards.count) cards.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        currentIndex = 0
                        reviewFinished = false
                    }) {
                        Text("Restart Review")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .padding()
            } else {
                // Normal Review Mode
                ProgressView(value: Double(currentIndex + 1),
                             total: Double(deck.cards.count))
                    .padding(.horizontal)
                    .animation(.easeInOut, value: currentIndex)
                
                Text("Card \(currentIndex + 1) of \(deck.cards.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                
                FlashcardView(
                    flashcard: deck.cards[currentIndex],
                    onSwipeLeft: {
                        if currentIndex < deck.cards.count - 1 {
                            withAnimation {
                                currentIndex += 1
                            }
                        } else {
                            withAnimation {
                                reviewFinished = true
                            }
                        }
                    },
                    onSwipeRight: {
                        if currentIndex > 0 {
                            withAnimation {
                                currentIndex -= 1
                            }
                        }
                    }
                )
            }
        }
        .navigationTitle(deck.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

