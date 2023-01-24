//
//  ContentView.swift
//  WatchMirror Watch App
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)

            Text("Hello, world!")
        }
        .gesture(
            DragGesture()
                .onChanged { newValue in
//                    print(newValue.location)
                    Connectivity.shared.send(point: newValue.location)
                }
        )
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
