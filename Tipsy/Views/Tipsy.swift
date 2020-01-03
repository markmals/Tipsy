import SwiftUI

struct Tipsy: View {
    @State private var selectedField = Header.Field.subtotal
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                Header(activeField: self.$selectedField)
                Keypad(activeField: self.$selectedField)
            }
        }
    }
}
