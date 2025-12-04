//
//  Cart.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 04/12/25.
//

import Foundation
internal import Combine

class Cart: ObservableObject {
    
    @Published private(set) var items: [Product] = [Product]()
    
    var cartTotal: Double {
        return items.reduce(0) { result, product in
            result + product.price
        }
    }
    
    var cartCount: Int {
        items.count
    }
    
    func addToCart(_ item: Product) {
        items.append(item)
    }
    
    func clear() {
        items = []
    }
}
