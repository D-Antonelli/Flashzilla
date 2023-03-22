//
//  ContentView - ViewModel.swift
//  Flashzilla
//
//  Created by Derya Antonelli on 22/03/2023.
//

import Foundation

    @MainActor class ViewModel: ObservableObject {
        @Published var cards: [Card] = []

        func loadData() {
            if let data = UserDefaults.standard.data(forKey: "Cards") {
                if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                    cards = decoded
                }
            }
        }
    }

