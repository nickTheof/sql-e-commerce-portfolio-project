# E-commerce Database Schema

This README file provides an overview and description of the e-commerce database schema. The schema consists of seven tables designed to store information about users, products, categories, orders, reviews, and inventory transactions.

## Tables

### 1. `users`

The `users` table stores information about the users of the e-commerce platform.

- `user_id`: Unique identifier for each user (Primary Key).
- `username`: Unique username for each user (VARCHAR, max length 50).
- `hashed_password`: Hashed password for user authentication (VARCHAR, max length 255).
- `email`: Unique email address for each user (VARCHAR, max length 100).
- `created_at`: Timestamp when the user account is created (defaults to current time).

### 2. `categories`

The `categories` table stores the different categories of products available on the platform.

- `category_id`: Unique identifier for each category (Primary Key).
- `category_name`: Name of the category (VARCHAR, max length 50).

### 3. `products`

The `products` table stores information about the products available for sale.

- `product_id`: Unique identifier for each product (Primary Key).
- `name`: Name of the product (VARCHAR, max length 100).
- `description`: Description of the product (TEXT).
- `price`: Price of the product (DECIMAL, 10 digits with 2 decimal places).
- `stock_quantity`: Quantity of the product in stock (INT).
- `category_id`: Foreign key referencing the `category_id` in the `categories` table.

### 4. `orders`

The `orders` table stores information about orders placed by users.

- `order_id`: Unique identifier for each order (Primary Key).
- `user_id`: Foreign key referencing the `user_id` in the `users` table.
- `order_date`: Timestamp when the order is placed (defaults to current time).
- `status`: Status of the order (VARCHAR, max length 50).

### 5. `order_items`

The `order_items` table stores information about the items in each order.

- `order_item_id`: Unique identifier for each order item (Primary Key).
- `order_id`: Foreign key referencing the `order_id` in the `orders` table.
- `product_id`: Foreign key referencing the `product_id` in the `products` table.
- `quantity`: Quantity of the product ordered (INT).
- `price_at_purchase`: Price of the product at the time of purchase (DECIMAL, 10 digits with 2 decimal places).

### 6. `reviews`

The `reviews` table stores reviews written by users for products.

- `review_id`: Unique identifier for each review (Primary Key).
- `product_id`: Foreign key referencing the `product_id` in the `products` table.
- `user_id`: Foreign key referencing the `user_id` in the `users` table.
- `rating`: Rating given by the user (INT, between 1 and 5).
- `comment`: Text comment for the review (TEXT).
- `review_date`: Timestamp when the review is written (defaults to current time).

### 7. `inventory_transactions`

The `inventory_transactions` table stores information about inventory transactions.

- `transaction_id`: Unique identifier for each transaction (Primary Key).
- `product_id`: Foreign key referencing the `product_id` in the `products` table.
- `quantity`: Quantity involved in the transaction (INT).
- `transaction_date`: Timestamp when the transaction occurred (defaults to current time).
- `transaction_type`: Type of transaction ('IN' for adding to inventory, 'OUT' for removing from inventory) (VARCHAR, max length 3).

## Relationships

- Each product belongs to a category (`products.category_id` references `categories.category_id`).
- Each order is placed by a user (`orders.user_id` references `users.user_id`).
- Each order item is part of an order (`order_items.order_id` references `orders.order_id`) and refers to a product (`order_items.product_id` references `products.product_id`).
- Each review is written by a user (`reviews.user_id` references `users.user_id`) for a product (`reviews.product_id` references `products.product_id`).
- Each inventory transaction involves a product (`inventory_transactions.product_id` references `products.product_id`).

## Constraints

- `users.username` and `users.email` must be unique.
- `categories.category_name` must be unique.
- `reviews.rating` must be between 1 and 5.
- `inventory_transactions.transaction_type` must be either 'IN' or 'OUT'.

This database schema is designed to handle the fundamental aspects of an e-commerce platform, providing a structure for managing users, products, categories, orders, reviews, and inventory transactions.

