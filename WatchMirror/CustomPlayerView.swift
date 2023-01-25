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

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {}

    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(player: player)
    }

}

// View that stores PlayerView and PlayerControlsView (only play/pause button for now).
struct PlayerContainerView : View {

    private let player: AVPlayer
    private var playerControlsView: PlayerControlsView

    init(player: AVPlayer) {
        self.player = player
        playerControlsView = PlayerControlsView(player: player)
    }
    
    var body: some View {
        ZStack {
            PlayerView(player: player)
            playerControlsView
        }
    }

    // Send touch coordinates deeper to PlayerControlsView.
    func didTap(_ point: CGPoint) {
        playerControlsView.didTap(point)
    }
}

struct PlayerControlsView: View {

    @ObservedObject private var viewModel = ViewModel()
    let player: AVPlayer

    var body: some View {
        GeometryReader { geomerty in
            Button(action: {
                buttonAction()
            }) {
                Image(systemName: viewModel.playerPaused ? "play" : "pause")
                    .tint(.white)
                    .frame(width: viewModel.buttonSize.width, height: viewModel.buttonSize.height)
                    .background(RoundedRectangle(cornerRadius: viewModel.buttonSize.width/2).stroke(.white))
            }
            .position(x: geomerty.size.width/2, y: geomerty.size.height/2)
            // Save button frame (coordinates and size) after screen was apeeared.
            .onAppear {
                viewModel.buttonFrame = CGRect(x: (geomerty.size.width - viewModel.buttonSize.width)/2,
                                               y: (geomerty.size.height - viewModel.buttonSize.height)/2,
                                               width: viewModel.buttonSize.width,
                                               height: viewModel.buttonSize.height)
            }
            // Play/pause video after changing playPaused.
            .onReceive(viewModel.$playerPaused) { playerPaused in
                if playerPaused { self.player.pause() }
                else { self.player.play() }
            }
        }

    }

    // Check if play/pause button contains user's touch coordinates.
    func didTap(_ point: CGPoint) {
        if viewModel.buttonFrame.contains(point) {
            buttonAction()
        }
    }

    // Change playPaused value.
    func buttonAction() {
        viewModel.playerPaused.toggle()
    }
}

extension PlayerControlsView {
    // ViewModel class is implemented for proper work flow with observed states and properties (such as playerPaused and buttonFrame).
    @MainActor class ViewModel: ObservableObject {
        @Published var playerPaused = true
        @Published var buttonFrame: CGRect = .zero
        let buttonSize = CGSize(width: 100, height: 100)
    }
}

// UIKit view used in PlayerView SwiftUI struct.
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
