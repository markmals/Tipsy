import Foundation
import Combine

class Bill: ObservableObject {
    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()
    
    @Clamping(range: 0...9_999_999) var subtotal: Double = 0.0 {
        didSet {
            publishedSubtotal = subtotal
        }
    }
    
    @Clamping(range: 0...1) var percentage: Double = 0.18 {
        didSet {
            publishedPercentage = percentage
        }
    }
    
    @Clamping(range: 0...50) var people: Int = 1 {
        didSet {
            publishedPeople = people
        }
    }
    
    // These @Published properties are necessary for the ObservableObject to update the UI when
    // these values change.
    //
    // I'm open to better architecture ideas for doing this.
    @Published private var publishedSubtotal: Double = 0.0
    @Published private var publishedPercentage: Double = 0.18
    @Published private var publishedPeople: Int = 1
    
    var tipAmount: Double { round(subtotal * percentage) }
    var total: Double { subtotal + tipAmount }
    var totalPerPerson: Double { round(total / Double(people)) }
    
    var formattedSubtotal: String {
        formatter.string(from: NSNumber(value: subtotal)) ?? ""
    }
    
    var wholeTipPercentage: Int {
        get { return Int(percentage * 100) }
        set { percentage = Double(newValue) / 100 }
    }
    
    var formattedTipPercentage: String {
        "\(wholeTipPercentage)%"
    }
    
    var formattedTipAmount: String {
        formatter.string(from: NSNumber(value: tipAmount)) ?? ""
    }
    
    var formattedTotal: String {
        formatter.string(from: NSNumber(value: total)) ?? ""
    }
    
    var formattedTotalPerPerson: String {
        formatter.string(from: NSNumber(value: totalPerPerson)) ?? ""
    }
    
    // TODO: Clean up duplicate rounding logic
    
    private func round(_ number: Double, withScaleFactor scaleFactor: Double = 1_000) -> Double {
        Darwin.round(scaleFactor * number) / scaleFactor
    }
    
    private func calculateTipPercentage(from total: Double) -> Double {
        (total - subtotal) / subtotal
    }
    
    private func round(up: Bool) {
        func rounding(_ number: Double, to nearest: Double, up: Bool) -> Double {
            Double(Int(nearest * (up ? ceil(number / nearest) : floor(number / nearest))))
        }
        
        // FIXME: This only rounds $12.87 to $13.00 and $13.00 to $20.00
        // I expect this to round $20 up to $100 and $100 up to $1000 one more time before doing nothing
        if total.truncatingRemainder(dividingBy: 1) == 0 {
            percentage = calculateTipPercentage(from: rounding(total, to: 10.0, up: up))
        } else if total.truncatingRemainder(dividingBy: 10) == 0 {
            percentage = calculateTipPercentage(from: rounding(total, to: 100.0, up: up))
        } else if total > 1_000_000 {
            // Do nothing
        } else {
            percentage = calculateTipPercentage(from: up ? ceil(total) : floor(total))
        }
    }
    
    func roundUp() { round(up: true) }
    func roundDown() { round(up: false) }
    
    func clearSubtotal() { subtotal = 0 }
    func clearPercentage(defaultTipPercentage: Double = 0.18) { percentage = defaultTipPercentage }
    func clearPeople() { people = 1 }
    
    func clearAll(defaultTipPercentage: Double) {
        clearSubtotal()
        clearPercentage(defaultTipPercentage: defaultTipPercentage)
        clearPeople()
    }
}

extension Bill: Equatable, Hashable {
    static func == (lhs: Bill, rhs: Bill) -> Bool {
        lhs.subtotal == rhs.subtotal &&
        lhs.people == rhs.people &&
        lhs.percentage == rhs.percentage
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(subtotal)
        hasher.combine(people)
        hasher.combine(percentage)
    }
}
