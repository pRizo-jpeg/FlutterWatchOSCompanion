import SwiftUI

struct PageOneView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    var body: some View {
        VStack {
            if let image = watchDelegate.image {
             
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                
            } else {
                Text("No image received")
            }
            
            Text("\(watchDelegate.msg)")
                .font(.subheadline)
            
            Text("Value: \(watchDelegate.value)")
                .font(.subheadline)
            
            Button(action: {
                /// Call the sendMessageToiOS method on the extensionDelegate to send a message
                watchDelegate.sendMessageToiOS(message: "Hello from WatchOS!")
            }) {
                
                Text("Send Message")
            }
            .padding()
            
        }
    }
}
