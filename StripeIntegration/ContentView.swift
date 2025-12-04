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
        
        let url = URL(string: "http://192.168.1.28:4242/create-payment-intent")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "currency": "inr",
            "items": cart.items.map { item -> [String: Any] in
                // ensure server receives amount in cents (or adapt to your server's expected format)
                return ["amount": Int(item.price * 100)] // if price is Double in dollars
            }
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response or status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
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
                            if let clientSecret = clientSecret {
                                PaymentConfig.shared.paymentIntentClientSecret = clientSecret
                                DispatchQueue.main.async {
                                    isActive = true
                                }
                            } else {
                                // Handle error - maybe show an alert
                                print("Failed to fetch client secret")
                            }
                        }
                    }
                }
                
                .navigationTitle("Products")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        ZStack {
                            Image(systemName: "cart")
                            
                            if cart.cartCount > 0 {
                                Text("\(cart.cartCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 15, height: 15)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -10)
                            }
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
