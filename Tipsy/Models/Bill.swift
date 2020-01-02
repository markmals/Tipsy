import Foundation
import Combine

class Bill: ObservableObject {
    class Tip: ObservableObject {
        @Published var percentage: Double = 0.18
        @Published var people: Int = 1
    }
    
    @Published var subtotal: Double = 0.0
    @Published var tip = Tip()
    
    private var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = tip.objectWillChange.sink { (_) in
            self.objectWillChange.send()
        }
    }
    
    var tipAmount: Double { round(subtotal * tip.percentage) }
    var total: Double { subtotal + tipAmount }
    var totalPerPerson: Double { round(total / Double(tip.people)) }
    
    var formattedSubtotal: String {
        String(format: "$%.2f", Double(subtotal))
    }
    
    var wholeTipPercentage: Int {
        get { return Int(tip.percentage * 100) }
        set { tip.percentage = Double(newValue) / 100 }
    }
    
    var formattedTipPercentage: String {
        "\(wholeTipPercentage)%"
    }
    
    var formattedTipAmount: String {
        String(format: "$%.2f", tipAmount)
    }
    
    var formattedTotal: String {
        String(format: "$%.2f", total)
    }
    
    var formattedTotalPerPerson: String {
        String(format: "$%.2f", totalPerPerson)
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
            tip.percentage = calculateTipPercentage(from: rounding(total, to: 10.0, up: up))
        } else if total.truncatingRemainder(dividingBy: 10) == 0 {
            tip.percentage = calculateTipPercentage(from: rounding(total, to: 100.0, up: up))
        } else if total > 1_000 {
            // Do nothing
        } else {
            tip.percentage = calculateTipPercentage(from: up ? ceil(total) : floor(total))
        }
    }
    
    func roundUp() { round(up: true) }
    func roundDown() { round(up: false) }
    
    func clearSubtotal() { subtotal = 0 }
    func clearPercentage(defaultTipPercentage: Double) { tip.percentage = defaultTipPercentage }
    func clearPeople() { tip.people = 1 }
    
    func clearAll(defaultTipPercentage: Double) {
        clearSubtotal()
        clearPercentage(defaultTipPercentage: defaultTipPercentage)
        clearPeople()
    }
}

extension Bill: Equatable, Hashable {
    static func == (lhs: Bill, rhs: Bill) -> Bool {
        lhs.subtotal == rhs.subtotal &&
        lhs.tip.people == rhs.tip.people &&
        lhs.tip.percentage == rhs.tip.percentage
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(subtotal)
        hasher.combine(tip.people)
        hasher.combine(tip.percentage)
    }
}
