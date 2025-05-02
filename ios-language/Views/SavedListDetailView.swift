//
//  SavedListDetailView.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/1/25.
//
//import SwiftUI
//
//struct SavedListDetailView: View {
//    let list: VocabList
//    @StateObject var speaker = SpeechPlayer()
//    @State private var isSpeaking = false
//    @State private var isPaused = false
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text(list.name)
//                .font(.title)
//
//            List(list.vocabPairs, id: \.id) { pair in
//                VStack(alignment: .leading) {
//                    Text(pair.word).fontWeight(.bold)
//                    Text(pair.translated_word).foregroundColor(.secondary)
//                }
//            }
//
//            HStack(spacing: 20) {
//                Button {
//                    if isSpeaking {
//                        if isPaused {
//                            speaker.resume()
//                        } else {
//                            speaker.pause()
//                        }
//                        isPaused.toggle()
//                    } else {
//                        speaker.play(vocabPairs: list.vocabPairs)
//                        isSpeaking = true
//                        isPaused = false
//                    }
//                } label: {
//                    Text(isSpeaking ? (isPaused ? "Resume" : "Pause") : "Play")
//                }
//
//                Button("Stop") {
//                    speaker.stop()
//                    isSpeaking = false
//                    isPaused = false
//                }
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .padding()
//    }
//}

import SwiftUI
import AVFoundation

struct SavedListDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode

    @State var list: VocabList
    @State private var isEditing = false
    @State private var wordBlocks: [WordBlock] = []

    @StateObject private var speaker = SpeechPlayer()
    @State private var isSpeaking = false

    var body: some View {
        VStack {
            if isEditing {
                List {
                    ForEach(wordBlocks, id: \.id) { block in
                        VStack(alignment: .leading) {
                            TextField("Enter word", text: binding(for: block).word)
                                .textFieldStyle(.roundedBorder)
                            TextField("Enter translation", text: binding(for: block).translatedWord)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding(.vertical, 4)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }

                Button {
                    wordBlocks.append(WordBlock(word: "", translatedWord: ""))
                } label: {
                    Label("Add Word Pair", systemImage: "plus.circle.fill")
                        .labelStyle(.titleAndIcon)
                        .padding()
                }

            } else {
                VStack(spacing: 12) {
                    let sourceLang = supportedLanguages.first(where: { $0.code == list.firstLangCode }) ?? supportedLanguages[0]
                    let targetLang = supportedLanguages.first(where: { $0.code == list.secondLangCode }) ?? supportedLanguages[1]
                    HStack {
                        Text("\(sourceLang.name)")
                            .font(.subheadline)
                            
                        
                        Image(systemName: "arrow.right")


                        Text("\(targetLang.name)")
                            .font(.subheadline)
                            
                    }
                    List {
                        ForEach(list.vocabPairs, id: \.id) { pair in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(pair.word)
                                        .bold()
                                        .foregroundColor(speaker.currentSpokenWord == pair.word ? .blue : .primary)
                                    
                                    Spacer()

                                    Text(pair.translated_word)
                                        .foregroundColor(speaker.currentSpokenWord == pair.translated_word ? .blue : .primary)
                                }
                            }
                        }
                    }

                    HStack(spacing: 20) {
                        Button(isSpeaking ? "Stop" : "Play") {
                            if isSpeaking {
                                speaker.stop()
                                isSpeaking = false
                            } else {
                                speaker.play(
                                    vocabPairs: list.vocabPairs,
                                    firstLang: sourceLang.code,
                                    secondLang: targetLang.code
                                )
                                isSpeaking = true
                            }
                        }
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Centered title
            ToolbarItem(placement: .principal) {
                Text(list.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }

            // Edit/Done button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        saveChanges()
                        editMode?.wrappedValue = .inactive
                        isEditing = false
                    } else {
                        speaker.stop()
                        isSpeaking = false

                        wordBlocks = list.vocabPairs.map {
                            WordBlock(word: $0.word, translatedWord: $0.translated_word)
                        }
                        editMode?.wrappedValue = .active
                        isEditing = true
                    }
                }
            }
        }
        .onDisappear {
            speaker.stop()
            isSpeaking = false
        }
    }

    // MARK: - Helper Methods

    func binding(for block: WordBlock) -> Binding<WordBlock> {
        guard let index = wordBlocks.firstIndex(of: block) else {
            fatalError("WordBlock not found")
        }
        return $wordBlocks[index]
    }

    func move(from source: IndexSet, to destination: Int) {
        wordBlocks.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        wordBlocks.remove(atOffsets: offsets)
    }

    func saveChanges() {
        list.vocabPairs = wordBlocks.map {
            VocabPair(word: $0.word, translated_word: $0.translatedWord)
        }
        try? context.save()
    }
}



#Preview {
    let sampleList = VocabList(
        name: "Fruits",
        vocabPairs: [
            VocabPair(word: "apple", translated_word: "táo"),
            VocabPair(word: "banana", translated_word: "chuối"),
            VocabPair(word: "grape", translated_word: "nho")
        ],
        firstLangCode: "en-US",
        secondLangCode: "vi-VN"
    )
    SavedListDetailView(list: sampleList)
}

