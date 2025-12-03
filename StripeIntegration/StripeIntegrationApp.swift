//
//  StripeIntegrationApp.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 03/12/25.
//

import SwiftUI
import Stripe

@main
struct StripeIntegrationApp: App {
    
    init () {
        StripeAPI.defaultPublishableKey = "pk_test_51SaAFBJXZyrqtYfmbDtd6Nili3HqQIAI4s904JCcZPmr9py2dWQmYmJZA1F7PsMOeSY5whMRQvvTDzzSwbWul02G00nJDltajR"
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Cart())
        }
    }
}
