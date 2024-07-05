-- Procedure to create a new user with the given username, hashed password, and email
CREATE OR REPLACE PROCEDURE UserCreate(
    username VARCHAR,
    hashed_password VARCHAR,
    email VARCHAR
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO users(username, hashed_password, email) VALUES (username, hashed_password, email);
COMMIT;
END;
$$;

-- Implementation of User Create procedure
CALL UserCreate('Nickolas', '111111111', 'the@out.com');


-- Procedure to create a new product category with the given category name
CREATE OR REPLACE PROCEDURE CategoryCreate(
    category_name VARCHAR
)
LANGUAGE "plpgsql"
AS $$
BEGIN
    INSERT INTO categories(category_name) VALUES (category_name);
COMMIT;
END;
$$;

-- Implementation of Category Create procedure
CALL CategoryCreate('Food');



-- Procedure to create a new product with the given name, description, price, category id, stock quantity
CREATE OR REPLACE PROCEDURE AddProduct(
    IN p_name TEXT,
    IN p_description TEXT,
    IN p_price NUMERIC,
    IN p_category_id INT,
    IN p_stock_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO products (name, description, price, category_id, stock_quantity)
    VALUES (p_name, p_description, p_price, p_category_id, p_stock_quantity);
END;
$$;

-- Implementation of Add Product procedure
CALL AddProduct('Product A', 'Description for Product A', 29.99, 1, 100)
