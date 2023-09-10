//
//  ContentView.swift
//  Blurry
//
//  Created by Krzysztof Czura on 10/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var textItems: [String] = []
    @State private var isAddingItemSheetPresented = false
    @State private var newItemText = ""
    var body: some View {
        NavigationView {
            if textItems.isEmpty {
                Text("No items")
                    .navigationTitle("Notes")
                    .toolbar {
                        Button {
                            isAddingItemSheetPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
            } else {
                List {
                    ForEach(textItems, id: \.self) { item in
                        Text(item)
                            .contextMenu {
                                Button {
                                    removeItem(item)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationTitle("Notes")
                .toolbar {
                    Button {
                        isAddingItemSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onChange(of: textItems, perform: { _ in
            saveText()
        })
        .onAppear(perform: {
            loadText()
        })
        .refreshable {
            loadText()
        }
        .sheet(isPresented: $isAddingItemSheetPresented, content: {
            NavigationView {
                List {
                    TextField("Add an item", text: $newItemText)
                        .textInputAutocapitalization(.sentences)
                }
                .navigationTitle("Add an item")
                .toolbar {
                    Button("OK") {
                        addItem()
                        isAddingItemSheetPresented.toggle()
                    }
                }
            }
        })
    }
    
    private func addItem() {
        textItems.append(newItemText)
        newItemText = ""
    }
    
    private func removeItem(_ item: String) {
        if let index = textItems.firstIndex(of: item) {
            textItems.remove(at: index)
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        textItems.remove(atOffsets: offsets)
    }
    
    private func saveText() {
        let textToSave = textItems.joined(separator: "/[split]/")
        UserDefaults.standard.set(textToSave, forKey: "text")
    }
    
    private func loadText() {
        if let savedText = UserDefaults.standard.string(forKey: "text") {
            textItems = savedText.components(separatedBy: "/[split]/")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
