//
//  Buton+Extensions.swift
//  Zaehler
//
//  Created by Hauke Marquard on 07.03.23.
//

import Foundation
import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    let scaleAmount: CGFloat
    
    init(scaleAmount: CGFloat) {
        self.scaleAmount = scaleAmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static func withPresableButtonStyle(scaleAmount: CGFloat = 0.95) -> Self {
        return .init(scaleAmount: scaleAmount)
    }
}
