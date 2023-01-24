//
//  PlayerViewController.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 24.01.2023.
//

import AVKit
import SwiftUI

struct PlayerView: UIViewRepresentable {

    let player: AVPlayer

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: player)
    }


}

struct PlayerContainerView : View {
    private let player: AVPlayer
    init(player: AVPlayer) {
        self.player = player
    }
    var body: some View {
        ZStack {
            PlayerView(player: player)
            PlayerControlsView(player: player)
        }
    }
}

struct PlayerControlsView : View {

    @State var playerPaused = true
    let player: AVPlayer
    var body: some View {
        Button(action: {
            self.playerPaused.toggle()
            if self.playerPaused {
                self.player.pause()
            }
            else {
                self.player.play()
            }
        }) {
            Image(systemName: playerPaused ? "play" : "pause")
                .tint(.white)
                .frame(width: 50, height: 50)
                .background(RoundedRectangle(cornerRadius: 25).stroke(.white))
        }

    }
}

class PlayerUIView: UIView {

    private let playerLayer = AVPlayerLayer()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    init(player: AVPlayer) {
        super.init(frame: .zero)
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }
}
