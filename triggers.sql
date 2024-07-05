-- Trigger Purpose: Ensure that stock quantity does not go below zero after an inventory transaction.
CREATE OR REPLACE FUNCTION check_stock_quantity()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.transaction_type = 'OUT' AND (SELECT stock_quantity FROM products WHERE product_id = NEW.product_id) - NEW.quantity < 0 THEN
        RAISE EXCEPTION 'Stock quantity cannot be negative';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--implementation of check_stock_quantity trigger
CREATE TRIGGER check_stock_quantity_trigger
BEFORE INSERT OR UPDATE ON inventory_transactions
FOR EACH ROW
EXECUTE FUNCTION check_stock_quantity();

-- Trigger Purpose: Automatically insert an inventory transaction record when a new product is added to the products table.

CREATE OR REPLACE FUNCTION log_initial_inventory()
RETURNS trigger AS $$
BEGIN
    INSERT INTO inventory_transactions (product_id, quantity, transaction_date, transaction_type)
    VALUES (NEW.product_id, NEW.stock_quantity, NOW(), 'IN');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--implementation of log_initial_inventory_trigger
CREATE TRIGGER log_initial_inventory_trigger
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_initial_inventory();

