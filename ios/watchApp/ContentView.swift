import SwiftUI

// The main view of the WatchOS app
struct ContentView: View {
    /// Access the environment object which is an instance of ExtensionDelegate
    @EnvironmentObject var extensionDelegate: ExtensionDelegate
    
    var body: some View {
        VStack {
            /// Check if an image has been received and assigned to the extensionDelegate.image property
            if let image = extensionDelegate.image {
                /// If an image is available, display it using the Image view
                Image(uiImage: image)
                    .resizable()  /// Make the image resizable
                    .scaledToFit()  /// Scale the image to fit within the specified frame
                    .frame(width: 70, height: 70) 
            } else {
                /// If no image is available, display a text message
                Text("No image received")
            }
            
            /// Display the received message using a Text view
            Text("\(extensionDelegate.msg)")
                .font(.subheadline)
            
            /// Display the received count value using a Text view
            Text("Value: \(extensionDelegate.value)")
                .font(.subheadline)
            
            /// Button to send a message to the iOS device
            Button(action: {
                /// Call the sendMessageToiOS method on the extensionDelegate to send a message
                extensionDelegate.sendMessageToiOS(message: "Hello from WatchOS!")
            }) {
                /// The label of the button
                Text("Send Message")
            }
            .padding()
        }
    }
}


