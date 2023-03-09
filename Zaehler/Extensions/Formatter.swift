//
//  Formatter.swift
//  Zaehler
//
//  Created by Hauke Marquard on 09.03.23.
//

import Foundation

func doubleToString(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    return formatter.string(from: NSNumber(value: value)) ?? ""
}
