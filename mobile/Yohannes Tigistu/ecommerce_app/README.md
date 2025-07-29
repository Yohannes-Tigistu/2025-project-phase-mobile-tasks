# ecommerce_app

A new Flutter project.

## Architecture Overview

This project uses a clean architecture approach, separating the codebase into Presentation, Domain, and Data layers for maintainability and testability.

- **Presentation Layer**: UI and user interaction
- **Domain Layer**: Business logic, use cases, repository interfaces
- **Data Layer**: Data sources (API/local), repository implementations

### Example Use Cases

- `create_new_product_usecase`: Create new products
- `delete_product_usecase`: Delete products
- `update_product_usecase`: Update products
- `view_all_products_usecase`: View all products
- `view_specific_product_usecase`: View a product by ID

## Data Flow

1. UI triggers a use case (e.g., fetch products)
2. Use case calls the repository interface
3. Repository implementation fetches/updates data from API or local storage
4. Data is mapped to entities and returned up to the UI
5. UI updates based on the result

For a detailed explanation, see `ARCHITECTURE.md` in the project root.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
