//
//  ContentView.swift
//  Blurry
//
//  Created by Krzysztof Czura on 10/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State var text: Array<String> = []
    @State var showSheet = false
    @State var textItemTemp = ""
    var body: some View {
        NavigationView {
            Group {
                if text.count <= 1 {
                    Text("No items")
                } else {
                    List {
                        ForEach((1...text.count - 1), id: \.self) { i in
                            Text(text[i])
                                .contextMenu {
                                    Button {
                                        text.remove(at: i)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }

                                }
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                Button {
                    showSheet.toggle()
                    // clear the temp
                    textItemTemp = ""
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onChange(of: text) { _ in
                save()
                load()
            }
            .onAppear {
                save()
                load()
            }
            .refreshable {
                save()
                load()
            }
        }
        .sheet(isPresented: $showSheet) {
            NavigationView {
                List {
                    TextField("item", text: $textItemTemp)
                }
                .navigationTitle("Add an item")
                .toolbar {
                    Button("add") {
                        text.append(textItemTemp)
                        showSheet.toggle()
                    }
                }
            }
        }
    }
    func save() -> Void {
        let temp = text.joined(separator: "/[split]/")
        let key = UserDefaults.standard
        key.set(temp, forKey: "text")
    }
    func load() -> Void {
        let key = UserDefaults.standard
        let temp = key.string(forKey: "text") ?? ""
        let tempArray = temp.components(separatedBy: "/[split]/")
        text = tempArray
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
