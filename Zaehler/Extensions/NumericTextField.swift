//
//  NumericTextField.swift
//  Zaehler
//
//  Created by Hauke Marquard on 07.03.23.
//

import SwiftUI
import Combine


struct NumericTextField: View {
    private let allowedCharacterSet = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: Locale.current.decimalSeparator ?? ".")).union(CharacterSet(charactersIn: ","))
    private let decimalSeparator = Locale.current.decimalSeparator ?? "."
//    private let decimalSeparator = ","
    
    @Binding var text: String
    
    var placeholder: String = "Enter number"
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.decimalPad)
            .onReceive(Just(text)) { newValue in
                let filtered = newValue.filter { allowedCharacterSet.contains($0.unicodeScalars.first!) }
                if filtered != newValue {
                    self.text = filtered
                } else if newValue.filter({$0 == Character(decimalSeparator)}).count > 1 {
                    self.text = String(newValue.dropLast())
                }
            }
    }
}

//extension NumericTextField {
//    public init(text: Binding<String>) {
//        self._text = text
//    }
//}
