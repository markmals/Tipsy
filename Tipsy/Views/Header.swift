import SwiftUI

struct Header: View {
    enum Field {
        case subtotal
        case tipPercentage
        case peopleSplit
    }
    
    @Binding var activeField: Field {
        didSet {
            switch activeField {
            case .subtotal:
                subtotalIsActive = true
                tipPercentageIsActive = false
                peopleSplitIsActive = false
            case .tipPercentage:
                subtotalIsActive = false
                tipPercentageIsActive = true
                peopleSplitIsActive = false
            case .peopleSplit:
                subtotalIsActive = false
                tipPercentageIsActive = false
                peopleSplitIsActive = true
            }
        }
    }
    
    @State var subtotalIsActive: Bool = true
    @State var tipPercentageIsActive: Bool = false
    @State var peopleSplitIsActive: Bool = false
    
    private func activateSubtotal() {
        activeField = .subtotal
    }
    
    private func activateTipPercentage() {
        activeField = .tipPercentage
    }
    
    private func activatePeopleSplit() {
        activeField = .peopleSplit
    }
    
    @EnvironmentObject private var bill: Bill
    
    private var subtotalButton: some View {
        SubtotalButton(isActive: $subtotalIsActive, action: {
            self.activateSubtotal()
        })
    }
    
    private func tipPercentageButton(width: CGFloat) -> some View {
        PillButton(
            label: bill.formattedTipPercentage + " Tip",
            sublabel: bill.formattedTipAmount,
            screenWidth: width,
            isActive: $tipPercentageIsActive,
            action: {
                self.activateTipPercentage()
        })
    }
    
    private func peopleSplitButton(width: CGFloat) -> some View {
        PillButton(
            label: "People",
            sublabel: String(bill.people),
            screenWidth: width,
            isActive: $peopleSplitIsActive,
            action: {
                self.activatePeopleSplit()
        })
    }
    
    private var subtitleLabel: some View {
        let color = Color.primarySemiOpaque
        
        return Group {
            if bill.people > 1 {
                HStack {
                    Text("\(self.bill.formattedTotalPerPerson)")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(color)
                    Spacer().frame(width: 4)
                    Text("each")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .foregroundColor(color)
                }
            } else {
                Text("Total")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(color)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                self.subtotalButton
                Spacer().frame(height: 20)
                self.tipPercentageButton(width: geometry.size.width)
                Spacer().frame(height: 10)
                self.peopleSplitButton(width: geometry.size.width)
                Spacer().frame(height: 20)
                Text(self.bill.formattedTotal)
                    .font(.system(size: 56, weight: .regular, design: .rounded))
                self.subtitleLabel
                Spacer()
            }
        }
    }
}

struct SubtotalButton: View {
    @EnvironmentObject var bill: Bill
    @Binding var isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(bill.formattedSubtotal)
                .font(.system(size: 56, weight: .regular, design: .rounded))
        }.buttonStyle(Style(isActive: $isActive))
    }
}

extension SubtotalButton {
    struct Style: ButtonStyle {
        @Binding var isActive: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(isActive ? .highlight : .primarySemiOpaque)
        }
    }
}
