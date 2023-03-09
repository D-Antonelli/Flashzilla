//
//  ContentView.swift
//  Flashzilla
//
//  Created by Derya Antonelli on 02/03/2023.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    var body: some View {
        CardView(card: Card.example)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
