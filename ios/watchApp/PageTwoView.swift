import SwiftUI

struct PageTwoView: View {
    @EnvironmentObject var watchDelegate: WatchDelegate
    var body: some View {
        CircularProgressBar(progress: 0.81, kWh: 33.08, timeRemaining: "1h 34m")
    }
}
