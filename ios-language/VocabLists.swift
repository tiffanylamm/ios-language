//
//  VocabLists.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/1/25.
//

import SwiftData
import Foundation

@Model
class VocabList {
    var id: UUID
    var name: String
    var vocabPairs: [VocabPair]
//    var firstLangCode: String
//    var secondLangCode: String
    
    var firstLangCode: String = "en-US"
    var secondLangCode: String = "vi-VN"

    init(name: String, vocabPairs: [VocabPair] = [], firstLangCode: String, secondLangCode: String) {
        self.id = UUID()
        self.name = name
        self.vocabPairs = vocabPairs
        self.firstLangCode = firstLangCode
        self.secondLangCode = secondLangCode
    }
}

struct VocabPair: Codable, Identifiable, Hashable {
    var id = UUID()
    var word: String
    var translated_word: String
}

