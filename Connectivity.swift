//
//  Connectivity.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 20.01.2023.
//

import Foundation
// 1
import WatchConnectivity

final class Connectivity: NSObject, ObservableObject {
    // 2
    static let shared = Connectivity()

    @Published var point: String = ""


    // 3
    override private init() {
        super.init()
        // 4
#if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
#endif

        // 5
        WCSession.default.delegate = self
        WCSession.default.activate()

    }

    public func send(point: CGPoint) {
        guard WCSession.default.activationState == .activated else {
            return
        }

        // 1
#if os(watchOS)
        // 2
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
#else
        // 3
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
#endif
        // 1
        let userInfo: [String: String] = [
            "point": "\(point.x) \(point.y)"
        ]

        // 2
        WCSession.default.sendMessage(userInfo, replyHandler: nil) { _ in }
    }

}

// MARK: - WCSessionDelegate
extension Connectivity: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
    }

#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // If the person has more than one watch, and they switch,
        // reactivate their session on the new device.
        session.activate()
    }
#endif
    // 1
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        // 2
        let key = "point"
        guard let point = userInfo[key] as? String else {
            return
        }

        self.point = point
        print(point)
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any]) {
        if let point = message["point"] as? String {
            print(point)
        }
    }


}
