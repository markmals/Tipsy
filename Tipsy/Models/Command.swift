import SwiftUI
import Combine

extension Keypad {
    enum Command: RawRepresentable {
        case number(Int)
        case dot
        case clear, clearAll
        case roundUp, roundDown
        
        init?(rawValue: String) {
            if let num = Int(rawValue) {
                self = .number(num)
            }
            
            switch rawValue {
            case ".": self = .dot
            case "C": self = .clear
            case "CA": self = .clearAll
            case "􀄨": self = .roundUp
            case "􀄩": self = .roundDown
            default: return nil
            }
        }

        var rawValue: String {
            switch self {
            case .number(let num): return "\(num)"
            case .dot: return "."
            case .clear: return "C"
            case .clearAll: return "CA"
            case .roundUp: return "􀄨"
            case .roundDown: return "􀄩"
            }
        }
        
        var background: Color {
            switch self {
            case .number(_), .dot:
                return Color.grey
            case .clear, .clearAll, .roundUp, .roundDown:
                return Color.highlight
            }
        }
        
        var backgroundPressed: Color {
            switch self {
            case .number(_), .dot:
                return Color.greyPressed
            case .clear, .clearAll, .roundUp, .roundDown:
                return Color.highlightSemiOpaque
            }
        }
        
        var foreground: Color {
            switch self {
            case .number(_), .dot:
                return Color.primary
            case .clear, .clearAll, .roundUp, .roundDown:
                return Color.white
            }
        }
    }
}
