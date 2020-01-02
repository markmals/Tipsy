import UIKit
import SwiftUI

extension Color {
    static var primary: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.white
            default: return Colors.black
            }
        }))
    }
    
    static var primarySemiOpaque: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.whiteSemiOpaque
            default: return Colors.blackSemiOpaque
            }
        }))
    }
    
    static var highlight: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.darkPurple
            default: return Colors.lightPurple
            }
        }))
    }
    
    static var highlightSemiOpaque: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.darkPurpleSemiOpaque
            default: return Colors.lightPurpleSemiOpaque
            }
        }))
    }
        
    static var grey: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.darkGrey
            default: return Colors.lightGrey
            }
        }))
    }
    
    static var greyPressed: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.darkGreyHighlight
            default: return Colors.lightGreyHighlight
            }
        }))
    }
    
    static var background: Color {
        Color(UIColor(dynamicProvider: { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark: return Colors.black
            default: return Colors.white
            }
        }))
    }
}

private struct Colors {
    static let white = UIColor.white
    static let whiteSemiOpaque = UIColor.white.withAlphaComponent(0.5)
    
    static let black = UIColor.black
    static let blackSemiOpaque = UIColor.black.withAlphaComponent(0.5)
    
    static let lightGrey = UIColor(red: 0.918, green: 0.918, blue: 0.918, alpha: 1) // #EAEAEA
    static let lightGreyHighlight = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    static let darkGrey = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) // #333333
    static let darkGreyHighlight = UIColor(red: 0.318, green: 0.318, blue: 0.318, alpha: 1)
    
    static let lightPurple = UIColor(red: 0.533, green: 0.403, blue: 1, alpha: 1) // #8867FF
    static let lightPurpleSemiOpaque = Colors.lightPurple.withAlphaComponent(0.5)
    
    static let darkPurple = UIColor(red: 0.418, green: 0.256, blue: 1, alpha: 1) // #6B41FF
    static let darkPurpleSemiOpaque = Colors.darkPurple.withAlphaComponent(0.5)
}
