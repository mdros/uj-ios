//
//  ContentView.swift
//  payments
//
//  Created by Michał Droś on 29/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State var showCardForm = false
    @State var transactionSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Item: Example Product")
                .font(.title)
            Text("Price: $10.00")
                .font(.headline)
            Button("Buy") {
                showCardForm = true
            }
            .buttonStyle(.borderedProminent)
        }
        .sheet(isPresented: $showCardForm) {
            CardFormView(isPresented: $showCardForm, transactionSuccess: $transactionSuccess)
        }
        .alert("Payment Successful", isPresented: $transactionSuccess) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct CardFormView: View {
    @Binding var isPresented: Bool
    @Binding var transactionSuccess: Bool
    
    @State var cardNumber = ""
    @State var cvv = ""
    @State var expiryDate = ""
    @State var showAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Details")) {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                    TextField("Expiry Date (MM/YY)", text: $expiryDate)
                        .keyboardType(.numbersAndPunctuation)
                }
                Button("Proceed") {
                    validateCard()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Enter Card Details")
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    func validateCard() {
        guard let url = URL(string: "http://127.0.0.1:8000/validate-card") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "card_number": cardNumber,
            "cvv": cvv,
            "expiry_date": expiryDate
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                NSLog("httpResponse : %",httpResponse);
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        transactionSuccess = true
                        isPresented = false
                    } else {
                        alertMessage = "Invalid card details. Please try again."
                        showAlert = true
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
