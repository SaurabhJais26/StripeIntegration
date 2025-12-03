//
//  Product.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 04/12/25.
//

import Foundation


struct Product: Identifiable, Codable {
    var id = UUID()
    let photo: String
    let price: Double
}

extension Product {
    
    static func all() -> [Product] {
        
        return [
            Product(photo: "🍎", price: 1),
            Product(photo: "🍌", price: 2),
            Product(photo: "🍒", price: 3),
            Product(photo: "🍉", price: 5),
        ]
        
    }
    
}
