//
//  ContentView.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 03/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var cart: Cart
    @State private var isActive: Bool = false
    
    private func startCheckout(completion: @escaping (String?) -> Void) {
        
        let url = URL(string: "http://localhost:4242/create-payment-intent")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "items": cart.items.map { item -> [String: Any] in
                // ensure server receives amount in cents (or adapt to your server's expected format)
                return ["amount": Int(item.price * 100)] // if price is Double in dollars
            }
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200
            else {
                completion(nil)
                return
            }
            
            let checkoutIntentResponse = try? JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
            completion(checkoutIntentResponse?.clientSecret)
            
        }.resume()
        
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                List(Product.all()) { product in
                    HStack {
                        Text(product.photo)
                        Text(formatPrice(product.price) ?? "")
                        Spacer()
                        Button {
                            // action
                            cart.addToCart(product)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                NavigationLink(isActive: $isActive) {
                    CheckoutView()
                } label: {
                    Button("Checkout") {
                        startCheckout { clientSecret in
                            
                            PaymentConfig.shared.paymentIntentClientSecret = clientSecret
                            
                            DispatchQueue.main.async {
                                isActive = true
                            }
                        }
                    }
                }
                
                .navigationTitle("Products")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        VStack {
                            Text("\(cart.cartCount)")
                            Image(systemName: "cart")
                        }
                    }
                }
                
            }
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Cart())
    }
}
