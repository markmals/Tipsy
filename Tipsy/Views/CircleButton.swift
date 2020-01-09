import SwiftUI
import UIKit

struct CircleButton: View {
    let screenWidth: CGFloat
    let spacing: CGFloat
    let model: Model
    
    // FIXME: Implement this using CoreHaptics to remove the UIKit dependency
    private let feedback = UIImpactFeedbackGenerator(style: .medium)
    
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
        Button(action: {
            self.feedback.impactOccurred()
            self.model.action()
        }) {
            symbol
        }.buttonStyle(
            Style(
                screenWidth: screenWidth,
                spacing: spacing,
                model: model
            )
        )
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
                .scaleEffect(configuration.isPressed ? 0.9 : 1)
        }
    }
}
