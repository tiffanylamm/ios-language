//
//  LanguageAppModelContainer.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/1/25.
//

import SwiftData

@MainActor
let modelContainer: ModelContainer = {
    let schema = Schema([VocabList.self])
    let config = ModelConfiguration("LanguageAppData", schema: schema)
    return try! ModelContainer(for: schema, configurations: [config])
}()
