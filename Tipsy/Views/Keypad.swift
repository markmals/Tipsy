import SwiftUI
import Combine

struct Keypad: View {
    @EnvironmentObject private var bill: Bill
    @Binding var field: Header.Field
    @State var dotWasHit: Bool = false
    
    @State var wholeNumbers = [Int]()
    @State var decimalNumbers = [Int]()
    
    let defaultTipPercentage: Double = 0.18
    
    private func clearSubtotalState() {
        dotWasHit = false
        wholeNumbers = []
        decimalNumbers = []
    }
    
    private func buttonAction(_ command: Command) {
        switch command {
        case .number(let amount):
            switch self.field {
            case .subtotal:
                if dotWasHit {
                    if decimalNumbers.count >= 2 {
                        clearSubtotalState()
                        wholeNumbers.append(amount)
                    } else {
                        decimalNumbers.append(amount)
                    }
                } else {
                    wholeNumbers.append(amount)
                }
                
                bill.subtotal = Double("\(wholeNumbers.map(String.init).joined()).\(decimalNumbers.map(String.init).joined())")!
            case .tipPercentage:
                if bill.wholeTipPercentage > 9 {
                    bill.wholeTipPercentage = amount
                } else {
                    bill.wholeTipPercentage = Int("\(bill.wholeTipPercentage)\(amount)")!
                }
            case .peopleSplit:
                if amount == 0 {
                    bill.tip.people = 1
                } else {
                    bill.tip.people = amount
                }
            }
        case .dot: self.dotWasHit = !self.dotWasHit
        case .clear:
            switch self.field {
            case .subtotal:
                self.bill.clearSubtotal()
                self.clearSubtotalState()
            case .tipPercentage:
                self.bill.clearPercentage(defaultTipPercentage: defaultTipPercentage)
            case.peopleSplit:
                self.bill.clearPeople()
            }
        case .clearAll:
            self.bill.clearAll(defaultTipPercentage: defaultTipPercentage)
            self.clearSubtotalState()
        case .roundUp:
            self.bill.roundUp()
        case .roundDown:
            self.bill.roundDown()
        }
    }
    
    private func makeModel(with command: Keypad.Command) -> CircleButton.Model {
        CircleButton.Model(
            label: command.rawValue,
            background: command.background,
            backgroundPressed: command.backgroundPressed,
            foreground: command.foreground,
            action: { self.buttonAction(command) })
    }
    
    private var models: [[CircleButton.Model]] {
        [[makeModel(with: .number(1)),
        makeModel(with: .number(2)),
        makeModel(with: .number(3)),
        makeModel(with: .clear)],
        [makeModel(with: .number(4)),
        makeModel(with: .number(5)),
        makeModel(with: .number(6)),
        makeModel(with: .clearAll)],
        [makeModel(with: .number(7)),
        makeModel(with: .number(8)),
        makeModel(with: .number(9)),
        makeModel(with: .roundUp)],
        [makeModel(with: .number(0)),
        makeModel(with: .dot),
        makeModel(with: .roundDown)]]
    }
    
    let spacing: CGFloat = 12
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: self.spacing) {
                ForEach(self.models, id: \.self) { row in
                    CircleButtonRow(screenWidth: geometry.size.width, spacing: self.spacing, models: row)
                }
            }
        }
    }
}
