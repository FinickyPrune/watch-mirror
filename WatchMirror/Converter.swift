//
//  Converter.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 24.01.2023.
//

import Foundation

// Singletone class is implemented to scale points from Apple Watch display to IPhone display.

class Converter {

    static let shared = Converter()

    private var scale: CGPoint = CGPoint(x: 1, y: 1)

    func config(watchSize: CGSize, iphoneSize: CGSize) {
        scale = CGPoint(x: iphoneSize.width / watchSize.width,
                        y: iphoneSize.height / watchSize.height)
    }

    func scaled(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scale.x, y: point.y * scale.y)
    }

}
