//
//  ContentView.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import SwiftUI
import AVKit

struct ContentView: View {

    // Observing Connectivity to get new touch points and display size from Apple Watch.
    @ObservedObject private var connectivity = Connectivity.shared

    // Config player with example video.
    var playerContainerView: PlayerContainerView = PlayerContainerView(player: AVPlayer(url: (Bundle.main.url(forResource: "movie", withExtension: "mp4"))!))

    var body: some View {
        GeometryReader { geomerty in
            playerContainerView
            // Config Converter when new display size is received.
                .onReceive(connectivity.$size) { size in
                    guard let size = size else { return }
                    Converter.shared.config(watchSize: size, iphoneSize: geomerty.size)
                }
            // Send touch scaled coordinates from Apple Watch into PlayerContainerView.
                .onReceive(connectivity.$point) { point in
                    playerContainerView.didTap(Converter.shared.scaled(point))
                }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
