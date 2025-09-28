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
                // Use rotation angle to decide which side to draw to avoid mirrored text during the 3D flip.
                let normalized = rotation.truncatingRemainder(dividingBy: 360)
                if normalized < 90 || normalized > 270 {
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
                        .accessibilityElement()
                        .accessibilityLabel(Text("Question"))
                        .accessibilityValue(Text(flashcard.question))
                        .accessibilityHint(Text("Double tap to flip. Swipe left for next, swipe right for previous."))
                } else {
                    // Back (Answer) — rotate 180 so it's upright when the container is rotated
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
                        .accessibilityElement()
                        .accessibilityLabel(Text("Answer"))
                        .accessibilityValue(Text(flashcard.answer))
                        .accessibilityHint(Text("Double tap to flip back. Swipe left for next, swipe right for previous."))
                }
            }
            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.6)
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .offset(x: dragOffset) // follow finger
            .animation(.spring(), value: dragOffset)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.6)) {
                    rotation += 180
                    // keep rotation in a reasonable range
                    rotation = rotation.truncatingRemainder(dividingBy: 360)
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
