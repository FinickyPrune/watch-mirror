//
//  Converter.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 24.01.2023.
//

import Foundation

class Converter {

    let scale: CGPoint

    init(watchSize: CGSize, iphoneSize: CGSize) {
        scale = CGPoint(x: iphoneSize.width / watchSize.width,
                        y: iphoneSize.height / watchSize.height)
        log.debug(scale)
    }

}

extension CGPoint {
    func toScale(_ scale: CGPoint) -> CGPoint {
        return CGPoint(x: self.x * scale.x, y: self.y * scale.y)
    }
}
