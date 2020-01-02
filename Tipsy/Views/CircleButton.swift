import SwiftUI
import CoreHaptics

struct CircleButton: View {
    let screenWidth: CGFloat
    let spacing: CGFloat
    let model: Model
    
    // FIXME: Implement this properly so tapping each button produces a short virbation
    func generateHapticFeedback() {
        let engine = try! CHHapticEngine()
        try! engine.start()

        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 20), CHHapticEventParameter(parameterID: .hapticIntensity, value: 20),
        ], relativeTime: 0)

        let pattern = try! CHHapticPattern(events: [hapticEvent], parameters: [])
        let hapticPlayer = try! engine.makePlayer(with: pattern)
        try! hapticPlayer.start(atTime: CHHapticTimeImmediate)
    }
    
    var symbol: some View {
        Group {
            if model.label == "􀄨" {
                Image(systemName: "arrow.up")
            } else if model.label == "􀄩" {
                Image(systemName: "arrow.down")
            } else {
                Text(model.label)
            }
        }
    }
    
    var body: some View {
        Button(action: model.action) {
            symbol
        }.buttonStyle(
            Style(
                screenWidth: screenWidth,
                spacing: spacing,
                model: model
            )
        )// .onTouchGesture(touchBegan: generateHapticFeedback)
    }
}

struct CircleButtonRow: View {
    let screenWidth: CGFloat
    let spacing: CGFloat
    let models: [CircleButton.Model]
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(self.models) { model in
                CircleButton(
                    screenWidth: self.screenWidth,
                    spacing: self.spacing,
                    model: model
                )
            }
        }
    }
}

extension CircleButton {
    struct Style: ButtonStyle {
        let screenWidth: CGFloat
        let spacing: CGFloat
        let model: Model
        
        var frame: (width: CGFloat, height: CGFloat) {
            let diameter = (screenWidth - spacing * 5) / 4
            
            return (
                width: (model.label != "0") ? diameter : diameter * 2 + spacing,
                height: diameter
            )
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.system(size: 34, weight: .regular, design: .rounded))
                .foregroundColor(model.foreground)
                .frame(width: frame.width, height: frame.height)
                .background(configuration.isPressed ? model.backgroundPressed : model.background)
                .cornerRadius(.infinity)
        }
    }
}
