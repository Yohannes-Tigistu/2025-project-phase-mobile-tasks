# Project Architecture and Data Flow

## Architecture Overview

This project follows a clean architecture approach, which separates the codebase into distinct layers to improve maintainability, scalability, and testability. The main layers are:

- **Presentation Layer**: Handles the UI and user interaction. Communicates with the domain layer via state management and controllers.
- **Domain Layer**: Contains business logic, use cases, and repository interfaces. This layer is independent of external dependencies.
- **Data Layer**: Responsible for data sources (API, local storage) and implements repository interfaces defined in the domain layer.

### Directory Structure

- `lib/features/Products/` - Contains product-related features, including domain, data, and presentation subfolders.
- `lib/core/` - Contains core utilities, error handling, and shared logic.

## Data Flow

1. **User Interaction**: The user interacts with the UI (Presentation Layer).
2. **State Management**: UI triggers actions (e.g., fetch products), which call use cases in the Domain Layer.
3. **Use Cases**: Use cases coordinate business logic and interact with repository interfaces.
4. **Repositories**: The repository implementation in the Data Layer fetches or updates data from remote APIs or local sources.
5. **Entities/Models**: Data is mapped between models (for storage/transport) and entities (for business logic).
6. **Result Propagation**: Results (success or failure) are returned up the layers to update the UI.

## Example: Fetching All Products

1. UI triggers `view_all_products_usecase`.
2. The use case calls the `ProductRepository` interface.
3. The repository implementation fetches data from the API or local storage.
4. Data is mapped to `Product` entities and returned to the use case.
5. The use case returns the result to the UI for display.


