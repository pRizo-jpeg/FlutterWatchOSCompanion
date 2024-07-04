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
    @Published var msg: String = ""
    @Published var user: User = User(name: nil, id: nil)
    @Published var image: UIImage? = nil
    
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
     
        if let imgData = message["img"] as? Data {
               DispatchQueue.main.async {
                   self.image = UIImage(data: imgData)
               }
           }
        if let count = message["count"] as? Int {
            DispatchQueue.main.async {
                self.value = count
            }
        }
        if let msg = message["msg"] as? String {
            DispatchQueue.main.async {
                self.msg = msg
            }
        }
        if let user = message["user"] as? User {
            DispatchQueue.main.async {
                self.user = user
            }
        }
    }
}

class User {
  var name: String?
  var id: Int?

  init(name: String?, id: Int?) {
    self.name = name
    self.id = id
  }
}
