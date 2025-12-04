//
//  CheckoutView.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 04/12/25.
//

import SwiftUI
import Stripe
import StripePaymentSheet

struct CheckoutView: View {
    
    @EnvironmentObject private var cart: Cart
    @State private var message: String = ""
    @State private var isSuccess: Bool = false
    @State private var paymentSheet: PaymentSheet?
    
    var body: some View {
        VStack {
            List {
                
                ForEach(cart.items) { item in
                    HStack {
                        Text(item.photo)
                        Spacer()
                        Text(formatPrice(item.price) ?? "")
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Total \(formatPrice(cart.cartTotal) ?? "")")
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    if let paymentSheet = paymentSheet {
                        PaymentSheet.PaymentButton(
                            paymentSheet: paymentSheet,
                            onCompletion: { result in
                                switch result {
                                case .completed:
                                    message = "Your payment has been successfully completed!"
                                    isSuccess = true
                                    cart.clear()
                                case .canceled:
                                    message = "Cancelled"
                                case .failed(let error):
                                    message = "Failed: \(error.localizedDescription)"
                                }
                            }
                        ) {
                            Text("Pay")
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Text("Loading Payment...")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.vertical)
                
                Text(message)
                    .font(.headline)
                
            }
            .onAppear {
                preparePaymentSheet()
            }
            
            NavigationLink(isActive: $isSuccess, destination: {
                Confirmation()
            }, label: {
                EmptyView()
            })
            
            .navigationTitle("Checkout")
            
        }
    }
    
    private func preparePaymentSheet() {
        guard let clientSecret = PaymentConfig.shared.paymentIntentClientSecret else {
            message = "Error: No client secret found."
            return
        }
        
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Stripe Integration Store"
        
        // Set Apple Pay Merchant ID to enable Apple Pay
        configuration.applePay = .init(merchantId: "merchant.com.astrosageai", merchantCountryCode: "US")
        
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CheckoutView().environmentObject(Cart())
        }
    }
}
