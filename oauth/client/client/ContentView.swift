//
//  ContentView.swift
//  client
//
//  Created by Michał Droś on 25/12/2024.
//
import SwiftUI


struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        if isLoggedIn {
            LoggedInView(logOutAction: logOut)
        } else {
            loginForm
        }
    }

    var loginForm: some View {
        VStack {
            Text("Log in first.")
                .font(.title)
                .padding()
            Form {
                TextField("Username", text: $username)
                    .autocapitalization(.none)
                SecureField("Password", text: $password)

                Button("Login") {
                    login()
                }
            }
            .padding()

            Text(message)
                .foregroundColor(.red)
        }
    }

    func login() {
        guard let url = URL(string: "http://127.0.0.1:8000/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        isLoggedIn = true
                    } else {
                        message = "Invalid username or password"
                    }
                }
            }
        }.resume()
    }

    func logOut() {
        NotificationCenter.default.post(name: NSNotification.Name("ResetState"), object: nil)
    }
}

struct LoggedInView: View {
    let logOutAction: () -> Void

    var body: some View {
        VStack {
            Text("Welcome! You are now logged in.")
                .font(.title)
                .padding()
            Button("Log Out", action: logOutAction)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            
        }
    }
}


#Preview {
    ContentView()
}
