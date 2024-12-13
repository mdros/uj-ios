import SwiftUI
import CoreData

// Core Data Product Entity
// Assume it has attributes like name (String), price (Double), and category (Relationship to Category)

struct ProductListView: View {
    // Fetch request for Core Data Products
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
    ) var products: FetchedResults<Product>

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View
    {
        NavigationView {
            List {
                ForEach(products, id: \Product.id) { product in
                    VStack(alignment: .leading) {
                        Text(product.name ?? "Unknown")
                            .font(.headline)
                        Text(String(format: "$%.2f", product.price))
                            .font(.subheadline)
                        if let categoryName = product.category?.name {
                            Text("Category: \(categoryName)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Category: None")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteProducts)
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addProduct) {
                        Label("Add Product", systemImage: "plus")
                    }
                }
            }
        }
    }

    // Add a new product
    private func addProduct() {
        withAnimation {
            let newProduct = Product(context: viewContext)
            newProduct.name = "New Product"
            newProduct.price = 0.0
            newProduct.id = UUID()

            saveContext()
        }
    }

    // Delete products
    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    // Save context
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

// Preview
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return ProductListView().environment(\.managedObjectContext, context)
    }
}

// Example PersistenceController
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Create example categories
        let electronicsCategory = Category(context: viewContext)
        electronicsCategory.name = "Electronics"

        let groceriesCategory = Category(context: viewContext)
        groceriesCategory.name = "Groceries"

        // Create example products
        for i in 0..<5 {
            let newProduct = Product(context: viewContext)
            newProduct.name = "Product \(i)"
            newProduct.price = Float(Double.random(in: 10...100))
            newProduct.id = UUID()
            newProduct.category = (i % 2 == 0) ? electronicsCategory : groceriesCategory
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
