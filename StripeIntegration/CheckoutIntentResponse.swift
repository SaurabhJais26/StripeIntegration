//
//  CheckoutIntentResponse.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 04/12/25.
//

import Foundation


struct CheckoutIntentResponse: Decodable {
    let clientSecret: String
}
