import SwiftUI

struct Product: Identifiable, Decodable {
    let id: Int
    let name: String
    let category_id: Int?
}

struct Category: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct ResponseWrapper<T: Decodable>: Decodable {
    let items: [T]
    let total: Int
}

struct ContentView: View {
    @State private var products: [Product] = []
    @State private var categories: [Category] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(products) { product in
                            HStack {
                                Text(product.name)
                                    .font(.headline)
                                Spacer()
                                Text(categoryName(for: product.category_id))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .onAppear(perform: loadData)
        }
    }

    private func categoryName(for categoryID: Int?) -> String {
        guard let categoryID = categoryID else {
            return "Uncategorized"
        }
        return categories.first(where: { $0.id == categoryID })?.name ?? "Unknown"
    }

    private func loadData() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()

        var fetchedProducts: [Product] = []
        var fetchedCategories: [Category] = []

        group.enter()
        fetch(endpoint: "/products") { (result: Result<ResponseWrapper<Product>, Error>) in
            switch result {
            case .success(let response):
                
                fetchedProducts = response.items
            case .failure(let error):
                print(error)
                errorMessage = error.localizedDescription
            }
            group.leave()
        }

        group.enter()
        fetch(endpoint: "/categories") { (result: Result<ResponseWrapper<Category>, Error>) in
            switch result {
            case .success(let response):
                fetchedCategories = response.items
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if errorMessage == nil {
                self.products = fetchedProducts
                self.categories = fetchedCategories
            }
            isLoading = false
        }
    }

    private func fetch<T: Decodable>(endpoint: String, completion: @escaping (Result<ResponseWrapper<T>, Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000\(endpoint)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ResponseWrapper<T>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
