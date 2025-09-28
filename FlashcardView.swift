//
//  FlashcardView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/28/25.
//

import SwiftUI

struct FlashcardView: View {
    var flashcard: FlashcardStruct
    var onSwipeLeft: (() -> Void)? = nil   // go to next card
    var onSwipeRight: (() -> Void)? = nil  // go to previous card
    
    @State private var flipped = false
    @State private var rotation = 0.0
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                if flipped {
                    // Back (Answer)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue)
                        .shadow(radius: 8)
                        .overlay(
                            Text(flashcard.answer)
                                .font(.title2)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .minimumScaleFactor(0.5)
                        )
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                } else {
                    // Front (Question)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.green)
                        .shadow(radius: 8)
                        .overlay(
                            Text(flashcard.question)
                                .font(.title2)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .minimumScaleFactor(0.5)
                        )
                }
            }
            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.6)
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .offset(x: dragOffset) // follow finger
            .animation(.spring(), value: dragOffset)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.6)) {
                    rotation += 180
                    flipped.toggle()
                }
            }
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        if value.translation.width < -100 {
                            // swiped left
                            onSwipeLeft?()
                        } else if value.translation.width > 100 {
                            // swiped right
                            onSwipeRight?()
                        }
                    }
            )
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}
