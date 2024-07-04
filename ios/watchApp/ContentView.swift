import SwiftUI

struct ContentView: View {
    @EnvironmentObject var extensionDelegate: ExtensionDelegate
    
    var body: some View {
        VStack {
            if let image = extensionDelegate.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Text("No image received")
            }
            Text("msg: \(extensionDelegate.msg)")
                .font(.headline)
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

