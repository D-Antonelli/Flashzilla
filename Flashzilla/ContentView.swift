//
//  ContentView.swift
//  Flashzilla
//
//  Created by Derya Antonelli on 02/03/2023.
//

import SwiftUI
import CoreHaptics

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditScreen = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image("table")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(viewModel.cards, id: \.self) { card in
                        CardView(card: card) {
                            withAnimation {
                                removeLastCard()
                            }
                        } swipeLeft: {
                            withAnimation {
                                removeAndAppend()
                            }
                        }
                        .stacked(at: viewModel.cards.firstIndex(of: card)!, in: viewModel.cards.count)
                        .allowsHitTesting(viewModel.cards.last == card)
                        .accessibilityHidden(true)
                    }
                    
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if viewModel.cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeLastCard()
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeLastCard()
                            }
                        } label: {
                            
                            
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if viewModel.cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        
        .onAppear(perform: resetCards)
    }
    
    
    func removeLastCard() {
        if viewModel.cards.isEmpty {
            isActive = false
        } else {
            viewModel.cards.removeLast()
        }
    }
    
    func removeAndAppend() {
        if viewModel.cards.isEmpty {
            isActive = false
        } else {
            let card = viewModel.cards.removeLast()
            
            viewModel.cards.insert(card, at: viewModel.cards.startIndex)
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        viewModel.loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
