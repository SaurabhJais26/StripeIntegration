//
//  Confirmation.swift
//  StripeIntegration
//
//  Created by Saurabh Jaiswal on 04/12/25.
//

import SwiftUI

struct Confirmation: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .opacity(isAnimated ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: isAnimated)
            
            Text("Payment Successful!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(isAnimated ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.5).delay(0.2), value: isAnimated)
            
            Text("Thank you for your purchase.")
                .font(.body)
                .foregroundColor(.gray)
                .opacity(isAnimated ? 1.0 : 0.0)
                .animation(.easeIn(duration: 0.5).delay(0.4), value: isAnimated)
            
            Spacer()
            
            Button(action: {
                // Dismiss to go back
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continue Shopping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .opacity(isAnimated ? 1.0 : 0.0)
            .animation(.easeIn(duration: 0.5).delay(0.6), value: isAnimated)
            
            Spacer().frame(height: 50)
            
        }
        .onAppear {
            isAnimated = true
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Confirmation_Previews: PreviewProvider {
    static var previews: some View {
        Confirmation()
    }
}

