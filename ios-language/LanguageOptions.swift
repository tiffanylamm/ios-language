//
//  LanguageOptions.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/2/25.
//

import Foundation

struct LanguageOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String // For TTS (e.g., "en-US", "vi-VN")
}

let supportedLanguages = [
    LanguageOption(name: "English", code: "en-US"),
    LanguageOption(name: "Vietnamese", code: "vi-VN"),
    LanguageOption(name: "Spanish", code: "es-ES"),
    LanguageOption(name: "French", code: "fr-FR")
]
