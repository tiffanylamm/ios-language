//
//  Debug.swift
//  ios-language
//
//  Created by Tiffany Lam on 5/1/25.
//
import SwiftUI
import SwiftData

struct DebugView: View {
    @Query var vocabLists: [VocabList]

    var body: some View {
        List(vocabLists) { list in
            Text(list.name)
        }
    }
}

#Preview {
    DebugView()
}
