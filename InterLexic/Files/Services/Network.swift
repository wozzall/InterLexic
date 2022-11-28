//
//  Network.swift
//  InterLexic
//
//  Created by George Worrall on 27/09/2022.
//

import Foundation
import Network
import SwiftUI

// An enum to handle the network status
enum NetworkStatus: String {
    case connected
    case disconnected
}

class Monitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")

    @Published var status: NetworkStatus = .connected
    @Published var isDisconnected: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    self.status = .connected
                    self.isDisconnected = false

                } else {
                    print("No connection.")
                    self.status = .disconnected
                    self.isDisconnected = true
                }
            }
        }
        monitor.start(queue: queue)
    }
}
