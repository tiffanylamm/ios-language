//
//  SavedListsView.swift
//  ios-language
//

import SwiftUI
import SwiftData

struct SavedListsView: View {
    @Query var vocabLists: [VocabList]
    @Environment(\.modelContext) private var context
    @State private var showAddView = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(vocabLists) { list in
                    NavigationLink(destination: SavedListDetailView(list: list)) {
                        Text(list.name)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            context.delete(list)
                            try? context.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("logo")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        Text("Saved Lists")
                            .font(.headline)
                    }
                }

                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showAddView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                NavigationStack {
                    ConversionView()
                }
            }
        }
    }
}




#Preview {
    SavedListsView()
}



