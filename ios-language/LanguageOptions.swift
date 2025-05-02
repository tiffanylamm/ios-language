//
//  LanguageOptions.swift
//  ios-language
//

import Foundation

struct LanguageOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String // For TTS (ex. "en-US", "vi-VN")
}

let supportedLanguages = [
    LanguageOption(name: "English", code: "en-US"),
    LanguageOption(name: "Vietnamese", code: "vi-VN"),
    LanguageOption(name: "Spanish", code: "es-ES"),
    LanguageOption(name: "French", code: "fr-FR")
]
