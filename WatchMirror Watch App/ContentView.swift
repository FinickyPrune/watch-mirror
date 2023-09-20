//
//  ContentView.swift
//  WatchMirror Watch App
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import SwiftUI

// Apple Watch ContentView simply sends to IPhone coordinates of each touch and display size.
// (We don't need to send size each time but for this simple solution it just saves time)

struct ContentView: View {

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(.black)
                .border(.red)
                .onTapGesture { gesture in
                    let point = CGPoint(x: max(0, gesture.x), y: max(0, gesture.y))
                    Connectivity.shared.send(point, geometry.size)
                }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
