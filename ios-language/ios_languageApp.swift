//
//  ios_languageApp.swift
//  ios-language
//

import SwiftUI
import SwiftData

@main
struct ios_languageApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: VocabList.self)
    }
}
