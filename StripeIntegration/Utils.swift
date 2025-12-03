//
//  Utils.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 04/12/25.
//

import Foundation


func formatPrice(_ price: Double) -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: price))
}
