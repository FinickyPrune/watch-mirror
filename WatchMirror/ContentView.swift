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

    var playerContainerView: PlayerContainerView = PlayerContainerView(player: AVPlayer(url: (Bundle.main.url(forResource: "movie", withExtension: "mp4"))!))

    var body: some View {
        GeometryReader { geomerty in
            playerContainerView
                .onReceive(connectivity.$size) { size in
                    guard let size = size else { return }
                    Converter.shared.config(watchSize: size, iphoneSize: geomerty.size)
                }
                .onReceive(connectivity.$point) { point in
                    guard let scale = Converter.shared.scale else { return }
                    let scaledPoint = point.toScale(scale)
                    playerContainerView.didTap(scaledPoint, parentSize: geomerty.size)
                }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
