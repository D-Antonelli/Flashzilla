//
//  ContentView.swift
//  Flashzilla
//
//  Created by Derya Antonelli on 02/03/2023.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0
    
    var body: some View {
        Text("Hello, World!")
            .scaleEffect(scale)
            .onTapGesture {
                withOptionalAnimation {
                    scale *= 1.5
                }
            }
    }
    
    func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        if UIAccessibility.isReduceMotionEnabled {
            return try body()
        } else {
            return try withAnimation(animation, body)
        }
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
