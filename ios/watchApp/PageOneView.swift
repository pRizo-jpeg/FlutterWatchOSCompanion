import SwiftUI

struct PageOneView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    var body: some View {
        VStack {
            if let image = watchDelegate.image {
                
                /// If an image is available, display it using the Image view
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                
            } else {
                Text("No image received")
            }
            
            /// Display the received message using a Text view
            Text("\(watchDelegate.msg)")
                .font(.subheadline)
            
            /// Display the received count value using a Text view
            Text("Value: \(watchDelegate.value)")
                .font(.subheadline)
            
            Button(action: {
                /// Call the sendMessageToiOS method on the extensionDelegate to send a message
                watchDelegate.sendMessageToiOS(message: "Hello from WatchOS!")
            }) {
                /// The label of the button
                Text("Send Message")
            }
            .padding()
            
        }
    }
}
