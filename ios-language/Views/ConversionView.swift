//
//  ConversionView.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/1/25.
//

import SwiftUI
import SwiftData

struct WordBlock: Identifiable, Hashable {
    var id = UUID()
    var word: String
    var translatedWord: String
}


struct ConversionView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var existingList: VocabList?

    @State private var listName = ""
    @State private var wordBlocks: [WordBlock] = []
    @State private var showConfirmation = false
    @State private var selectedLang1 = supportedLanguages[0]
    @State private var selectedLang2 = supportedLanguages[1]

    var body: some View {
        VStack(spacing: 0) {
            TextField("Vocab list name", text: $listName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Picker("First Language", selection: $selectedLang1) {
                    ForEach(supportedLanguages) { lang in
                        Text(lang.name).tag(lang)
                }
                }.pickerStyle(.menu)
                    .disabled(existingList != nil)

                Picker("Second Language", selection: $selectedLang2) {
                    ForEach(supportedLanguages) { lang in
                        Text(lang.name).tag(lang)
                }
                }.pickerStyle(.menu)
                    .disabled(existingList != nil)
            }

            List {
                ForEach($wordBlocks, id: \.id) { $block in
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Enter word", text: $block.word)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Enter translation", text: $block.translatedWord)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.vertical, 8)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .listStyle(.plain)

            HStack {
                Button {
                    wordBlocks.append(WordBlock(word: "", translatedWord: ""))
                } label: {
                    Label("Add Word Pair", systemImage: "plus.circle.fill")
                        .labelStyle(.titleAndIcon)
                }

                Spacer()

                Button("Save List") {
                    saveVocabList()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()

            if showConfirmation {
                Text("Vocab list saved!")
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
        }
        .navigationTitle(existingList == nil ? "Add New List" : "Edit List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton() // Enables drag handle in the List
        }
        .onAppear {
            if let existingList = existingList {
                listName = existingList.name
                wordBlocks = existingList.vocabPairs.map {
                    WordBlock(word: $0.word, translatedWord: $0.translated_word)
                }
            } else if wordBlocks.isEmpty {
                wordBlocks = (0..<4).map { _ in WordBlock(word: "", translatedWord: "") }
            }
        }
    }

    // MARK: - Helpers

    func binding(for block: WordBlock) -> Binding<WordBlock> {
        guard let index = wordBlocks.firstIndex(of: block) else {
            fatalError("Block not found")
        }
        return $wordBlocks[index]
    }

    func move(from source: IndexSet, to destination: Int) {
        wordBlocks.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        wordBlocks.remove(atOffsets: offsets)
    }

    func saveVocabList() {
        guard !listName.isEmpty else { return }

        let validPairs = wordBlocks.filter { !$0.word.isEmpty && !$0.translatedWord.isEmpty }
        guard !validPairs.isEmpty else { return }

        let listToSave: VocabList

        if let existing = existingList {
            existing.name = listName
            existing.vocabPairs = validPairs.map {
                VocabPair(word: $0.word, translated_word: $0.translatedWord)
            }
            listToSave = existing
        } else {
            listToSave = VocabList(
                name: listName,
                vocabPairs: validPairs.map {
                    VocabPair(word: $0.word, translated_word: $0.translatedWord)
                },
                firstLangCode: selectedLang1.code,
                secondLangCode: selectedLang2.code
            )
            context.insert(listToSave)
        }

        try? context.save()
        showConfirmation = true
    }
}

    

#Preview {
    ConversionView()
}


