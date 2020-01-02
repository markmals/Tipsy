import SwiftUI

extension CircleButton {
    struct Model: Identifiable, Hashable, Equatable {
        let id = UUID()
        let label: String
        let background: Color
        let backgroundPressed: Color
        let foreground: Color
        let action: () -> Void
        
        static func == (lhs: CircleButton.Model, rhs: CircleButton.Model) -> Bool {
            lhs.id == rhs.id &&
            lhs.label == rhs.label &&
            lhs.background == rhs.background &&
            lhs.foreground == rhs.foreground
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(label)
            hasher.combine(background)
            hasher.combine(foreground)
        }
    }
}
