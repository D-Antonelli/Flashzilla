//
//  EditCards.swift
//  Flashzilla
//
//  Created by Derya Antonelli on 16/03/2023.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ViewModel
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                    Button("Add template", action: addTemplate)
                }
                
                Section {
                    ForEach(0..<viewModel.cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(viewModel.cards[index].prompt)
                                .font(.headline)
                            Text(viewModel.cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            .onAppear(perform: loadData)
        }
    }
    
    func done() {
        dismiss()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                viewModel.cards = decoded
            }
        }
    }
    
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        viewModel.cards.insert(card, at: 0)
        saveData()
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func addTemplate() {
        let cards = [Card(prompt: "What is the capital city of France?", answer: "Paris"), Card(prompt: "Which chemical element has the symbol 'Au' on the periodic table?", answer: "Gold"), Card(prompt: "Who is the author of the famous play 'Romeo and Juliet'?", answer: "William Shakespeare"), Card(prompt: "Who was the first woman to win a Nobel Prize?", answer: "Marie Curie")]
        
        viewModel.cards = cards
        saveData()
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(viewModel.cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func removeCards(at offsets: IndexSet) {
        viewModel.cards.remove(atOffsets: offsets)
        saveData()
    }
    
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards(viewModel: ViewModel())
    }
}
