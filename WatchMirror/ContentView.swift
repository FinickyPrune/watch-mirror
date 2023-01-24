//
//  ContentView.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import SwiftUI
import AVKit

struct ContentView: View {

    @ObservedObject private var connectivity = Connectivity.shared

    var body: some View {
        PlayerContainerView(player: AVPlayer(url: (Bundle.main.url(forResource: "movie", withExtension: "mp4"))!))
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
