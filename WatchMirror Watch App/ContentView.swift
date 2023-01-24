//
//  ContentView.swift
//  WatchMirror Watch App
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(.black)
                .border(.red)
                .onTapGesture { gesture in
                    Connectivity.shared.send(gesture, geometry.size)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
