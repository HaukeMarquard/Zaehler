//
//  Currency.swift
//  Zaehler
//
//  Created by Hauke Marquard on 08.03.23.
//

import Foundation

func formatCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: value)) ?? ""
}
