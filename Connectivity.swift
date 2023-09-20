//
//  Connectivity.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import Foundation
import WatchConnectivity

// Enums are used to provide keys for message dictionary.

enum Size: String {
    case width
    case height
}

enum Point: String {
    case x
    case y
}

// Singletone class Connectivity is implemented for communication between Apple Watch and paired IPhone.

final class Connectivity: NSObject, ObservableObject {

    static let shared = Connectivity()

    @Published var size: CGSize?
    @Published var point: CGPoint = .zero

    override private init() {
        super.init()
#if !os(watchOS)
        guard WCSession.isSupported() else {
            log.error("Session is not supported.")
            return
        }
#endif
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // Send touch coordinates and display size from Apple Watch to IPhone.
    public func send(_ point: CGPoint, _ size: CGSize) {
        guard WCSession.default.activationState == .activated else {
            log.error("Session is not active.")
            return
        }
#if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            log.error("Companion app not installed.")
            return
        }
#else
        guard WCSession.default.isWatchAppInstalled else {
            log.error("Watch app not installed.")
            return
        }
#endif
        let userInfo: [String: Double] = [
            Point.x.rawValue: Double(point.x),
            Point.y.rawValue: Double(point.y),
            Size.width.rawValue: Double(size.width),
            Size.height.rawValue: Double(size.height)
        ]
        WCSession.default.sendMessage(userInfo, replyHandler: nil) { error in
            log.error(error.localizedDescription)
        }
    }

}

// MARK: - WCSessionDelegate

extension Connectivity: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        switch activationState {
        case .notActivated:
            log.debug("Session is not activated.")
        case .inactive:
            log.debug("Session is inactive.")
        case .activated:
            log.debug("Session is active.")
        @unknown default:
            log.debug("State is unknown.")
        }
    }

#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif

    // Receive message with touch coordinates and display size on IPhone.
    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        if let width = message[Size.width.rawValue] as? Double,
           let height = message[Size.height.rawValue] as? Double,
           let x = message[Point.x.rawValue] as? Double,
           let y = message[Point.y.rawValue] as? Double {
            DispatchQueue.main.async { [self] in
                if size == nil {
                    size = CGSize(width: width, height: height)
                }
                point = CGPoint(x: x, y: y)
            }
        }
    }
}
