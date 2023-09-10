//
//  ContentView.swift
//  Blurry
//
//  Created by Krzysztof Czura on 10/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State var text = ["text0", "text1", "text2", "text3"]
    @State var showsheet = false
    var body: some View {
        NavigationView {
            List((text), id: \.self) { i in
                Text(i)
            }
            .navigationTitle("Notes")
            .toolbar {
                Button {
                    showsheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showsheet) {
            NavigationView {
                Text("TEST")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
