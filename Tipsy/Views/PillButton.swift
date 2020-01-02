import SwiftUI

struct PillButton: View {
    let label: String
    let sublabel: String
    let screenWidth: CGFloat
    @Binding var isActive: Bool
    let action: () -> Void
    @EnvironmentObject var bill: Bill
    
    // TODO: Implement a method so that tapping each button produces a short virbation
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Spacer().frame(width: 30, height: 0)
                Text(label)
                    .font(.system(size: 22, weight: .regular, design: .rounded))
                    .foregroundColor(isActive ? Color.highlight : Color.primarySemiOpaque)
                Spacer()
                Text(sublabel)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.primary)
                Spacer().frame(width: 30, height: 0)
            }
        }.buttonStyle(Style(screenWidth: screenWidth, isActive: $isActive))
    }
}

extension PillButton {
    struct Style: ButtonStyle {
        let screenWidth: CGFloat
        @Binding var isActive: Bool
        
        let shape = RoundedRectangle(cornerRadius: .infinity, style: .continuous)
        
        var frame: (width: CGFloat, height: CGFloat) {
            (width: screenWidth * 0.85, height: 60)
        }
        
        // TODO: Figure out how to make the colors fade on isActive change
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: frame.width, height: frame.height)
                .background(isActive ? Color.clear : Color.grey)
                .clipShape(shape)
                .overlay(shape.stroke(isActive ? Color.highlight : Color.grey, lineWidth: 3))
        }
    }
}
