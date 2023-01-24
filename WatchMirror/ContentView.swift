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
    @State private var converter: Converter?

    var body: some View {
        GeometryReader { geomerty in
            PlayerContainerView(player: AVPlayer(url: (Bundle.main.url(forResource: "movie", withExtension: "mp4"))!))
                .onReceive(connectivity.$size) { size in
                    guard let size = size else { return }
                    log.debug(geomerty.size)
                    converter = Converter(watchSize: size, iphoneSize: geomerty.size)
                }
                .onReceive(connectivity.$point) { point in
                    guard let scale = converter?.scale else { return }
                    let scaledPoint = point.toScale(scale)
                    log.debug(scaledPoint)
                }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
