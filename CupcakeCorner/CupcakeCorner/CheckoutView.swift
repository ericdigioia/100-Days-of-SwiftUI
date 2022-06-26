//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Eric Di Gioia on 5/18/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var showingHTTPErrorMessage = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityHidden(true)
                
                Text("Your total is \(order.data.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
        .alert("There was an error with your Internet connection", isPresented: $showingHTTPErrorMessage) {
            Button("OK") {}
        } message: {
            Text("Please check your connection and try again.")
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            // send encoded order to server and get back server response inside "data"
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // decode JSON server response
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            // display this response (mirror of sent data) in an alert
            confirmationMessage = "Your order for \(decodedOrder.data.quantity)x \(OrderData.types[decodedOrder.data.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed.")
            showingHTTPErrorMessage = true
        }
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CheckoutView(order: Order())
                .preferredColorScheme(.dark)
        }
    }
}
