import SwiftUI

struct ContentView: View {
    @EnvironmentObject var extensionDelegate: ExtensionDelegate

    var body: some View {
        VStack {
            Text("Value: \(extensionDelegate.value)")
                .font(.headline)
            
            Button("Send Message") {
                sendMessage()
            }
            .padding()
        }
    }
    
    func sendMessage() {
        // send a message back to phone
    }
}

#Preview {
    ContentView()
}

