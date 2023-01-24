//
//  Logger.swift
//  WatchMirror
//
//  Created by Anastasia Kravchenko on 24.01.2023.
//

import SwiftyBeaver

let log: SwiftyBeaver.Type = {
    let log = SwiftyBeaver.self
    let console = ConsoleDestination()
    log.addDestination(console)
    return log
}()
