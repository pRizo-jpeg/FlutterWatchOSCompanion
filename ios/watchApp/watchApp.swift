//
//  watchApp.swift
//  watchApp
//
//  Created by Keeo on 3/7/24.
//

import SwiftUI
import WatchConnectivity

@main
struct watchApp: App {
    @WKExtensionDelegateAdaptor private var extensionDelegate: ExtensionDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(extensionDelegate)
        }
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject {
    @Published var value: Int = 0

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let count = message["count"] as? Int {
            DispatchQueue.main.async {
                self.value = count
            }
        }
    }
}
