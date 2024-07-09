import SwiftUI

struct CircularProgressBar: View {
    /// charging data values
    var progress: Double
    var kWh: Double
    var timeRemaining: String
    
    /// battery animation values
    @State private var isPlaying: Bool = false
    @State private var animationFrame: Int = 0
    @State private var timer: Timer? = nil
    let animationFrames = (1...4).map { "battery_anim\($0)" }
    let frameDuration: Double = 0.5
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.3)
                    .foregroundColor(Color.orange)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.orange)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: progress)
                    .frame(width: 120, height: 120)
                
                VStack(spacing: 3) {
                    if isPlaying {
                        Image(animationFrames[animationFrame])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .onAppear(perform: startAnimation)
                    } else {
                        Image(selectBatteryImage(for: progress))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(String(format: "%.0f %%", min(self.progress, 1.0) * 100.0))
                        .font(.system(size: 27))
                        .bold()
                        .foregroundColor(Color.orange)
                    
                    HStack(spacing: 0) {
                        Text(String(format: "%.2f", kWh))
                            .bold()
                            .font(.system(size: 11))
                            .foregroundColor(Color.orange)
                        
                        Text(" kWh")
                            .font(.system(size: 11))
                            .foregroundColor(Color.orange)
                    }.padding(.bottom, 10)
                }
            }.padding(.bottom, 15)
            Button(action: {
                isPlaying.toggle()
                if isPlaying {
                    startAnimation()
                } else {
                    stopAnimation()
                }
            }) {
                HStack {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.orange)
                    
                    Text(isPlaying ? "Stop charging" : "Resume charge")
                        .foregroundColor(Color.orange).bold()
                }
            }
        }
    }
    
    private func startAnimation() {
        stopAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: frameDuration, repeats: true) { _ in
            animationFrame = (animationFrame + 1) % animationFrames.count
            if !isPlaying {
                stopAnimation()
            }
        }
    }
    
    private func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func selectBatteryImage(for progress: Double) -> String {
        let percentage = progress * 100
        switch percentage {
        case 0...20:
            return "battery_anim1"
        case 21...50:
            return "battery_anim2"
        case 51...85:
            return "battery_anim3"
        case 86...100:
            return "battery_anim4"
        default:
            return "battery_anim4"
        }
    }
}
